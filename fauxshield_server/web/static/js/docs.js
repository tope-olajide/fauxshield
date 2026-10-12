/**
 * Documentation portal behaviour.
 *
 * Everything the page needs to be readable works without this file: the
 * sidebar, the sections, the tables, and the code are server-rendered, and the
 * language tabs on a code sample are plain radio inputs. What this adds is the
 * search dropdown, a copy button per code block, the sidebar toggle on a narrow
 * screen, and the "on this page" marker that follows the reader.
 */
(() => {
  'use strict';

  const $ = (selector, root = document) => root.querySelector(selector);
  const $$ = (selector, root = document) => Array.from(root.querySelectorAll(selector));

  /** Copy buttons on every code block. */
  const addCopyButtons = () => {
    for (const button of $$('.docs-copy')) {
      const code = $('code', button.parentElement);
      if (!code) continue;
      button.hidden = false;
      button.addEventListener('click', async () => {
        try {
          await navigator.clipboard.writeText(code.textContent ?? '');
          button.textContent = 'Copied';
        } catch {
          button.textContent = 'Press ⌘C';
        }
        setTimeout(() => {
          button.textContent = 'Copy';
        }, 1600);
      });
    }
  };

  /** The sidebar toggle, for a viewport too narrow for two columns. */
  const addSidebarToggle = () => {
    const toggle = $('#docs-sidebar-toggle');
    const sidebar = $('#docs-sidebar');
    if (!toggle || !sidebar) return;
    toggle.addEventListener('click', () => {
      const open = sidebar.classList.toggle('is-open');
      toggle.setAttribute('aria-expanded', open ? 'true' : 'false');
    });
  };

  /** Marks the section the reader is in, in the "on this page" list. */
  const trackHeadings = () => {
    const links = new Map();
    for (const link of $$('.docs-toc-link')) {
      links.set(link.getAttribute('href')?.slice(1) ?? '', link);
    }
    if (links.size === 0) return;

    const sections = $$('.docs-section');
    const mark = () => {
      let current = '';
      for (const section of sections) {
        if (section.getBoundingClientRect().top <= 120) current = section.id;
      }
      for (const [id, link] of links) {
        link.classList.toggle('is-active', id === current);
      }
    };
    mark();
    document.addEventListener('scroll', mark, { passive: true });
  };

  /**
   * The search dropdown.
   *
   * The index is one entry per section, fetched from the server, so a hit
   * points at the paragraph rather than the top of a long page. Matching is
   * case-insensitive, and every term has to appear somewhere in the entry, so
   * "webhook retry" finds the retries section rather than everything mentioning
   * either word.
   */
  const addSearch = () => {
    const input = $('#docs-search-input');
    const results = $('#docs-search-results');
    if (!input || !results) return;

    let index = null;
    let loading = null;
    let active = -1;

    const load = () => {
      if (index) return Promise.resolve(index);
      loading ??= fetch('/docs/search.json')
        .then((response) => (response.ok ? response.json() : { entries: [] }))
        .then((data) => {
          index = Array.isArray(data.entries) ? data.entries : [];
          return index;
        })
        .catch(() => {
          index = [];
          return index;
        });
      return loading;
    };

    const terms = (value) =>
      value
        .toLowerCase()
        .split(/\s+/)
        .filter((term) => term.length > 1);

    const matches = (entries, query) => {
      const wanted = terms(query);
      if (wanted.length === 0) return [];
      const scored = [];
      for (const entry of entries) {
        const haystack = `${entry.title} ${entry.section} ${entry.text} ${entry.group}`.toLowerCase();
        if (!wanted.every((term) => haystack.includes(term))) continue;
        const title = `${entry.title} ${entry.section}`.toLowerCase();
        let rank = 0;
        for (const term of wanted) {
          if (title.includes(term)) rank += 3;
          else if (haystack.includes(term)) rank += 1;
        }
        scored.push({ entry, rank });
      }
      scored.sort((a, b) => b.rank - a.rank || a.entry.path.localeCompare(b.entry.path));
      return scored.slice(0, 8).map((item) => item.entry);
    };

    const snippet = (entry, query) => {
      const text = entry.text ?? '';
      const term = terms(query)[0] ?? '';
      const at = term ? text.toLowerCase().indexOf(term) : -1;
      if (at < 0) return text.slice(0, 140);
      const start = Math.max(0, at - 60);
      return `${start > 0 ? '…' : ''}${text.slice(start, start + 160)}`;
    };

    const close = () => {
      results.hidden = true;
      results.replaceChildren();
      active = -1;
      input.setAttribute('aria-expanded', 'false');
    };

    const draw = (entries, query) => {
      results.replaceChildren();
      if (entries.length === 0) {
        const empty = document.createElement('p');
        empty.className = 'docs-search-empty';
        empty.textContent = `Nothing matches “${query}”. Try an endpoint name like product.list, a CLI command like alerts list, or an error like NotFoundException.`;
        results.append(empty);
        results.hidden = false;
        input.setAttribute('aria-expanded', 'true');
        return;
      }

      entries.forEach((entry, position) => {
        const link = document.createElement('a');
        link.className = 'docs-search-result';
        link.href = entry.path;
        link.setAttribute('role', 'option');
        link.dataset.index = String(position);

        const title = document.createElement('span');
        title.className = 'docs-search-result-title';
        title.textContent = `${entry.title} › ${entry.section}`;

        const text = document.createElement('span');
        text.className = 'docs-search-result-snippet';
        text.textContent = snippet(entry, query);

        link.append(title, text);
        results.append(link);
      });
      results.hidden = false;
      input.setAttribute('aria-expanded', 'true');
    };

    let pending;
    input.addEventListener('input', () => {
      const query = input.value;
      if (terms(query).length === 0) {
        close();
        return;
      }
      clearTimeout(pending);
      pending = setTimeout(async () => {
        const entries = await load();
        draw(matches(entries, query), query);
      }, 60);
    });

    input.addEventListener('keydown', async (event) => {
      const items = $$('.docs-search-result', results);
      if (event.key === 'Escape') {
        close();
        input.blur();
        return;
      }
      if (event.key === 'ArrowDown' || event.key === 'ArrowUp') {
        if (items.length === 0) return;
        event.preventDefault();
        active += event.key === 'ArrowDown' ? 1 : -1;
        if (active < 0) active = items.length - 1;
        if (active >= items.length) active = 0;
        items.forEach((item, position) => {
          item.classList.toggle('is-active', position === active);
        });
        items[active]?.scrollIntoView({ block: 'nearest' });
        return;
      }
      if (event.key === 'Enter') {
        const chosen = items[active] ?? items[0];
        if (chosen) {
          event.preventDefault();
          window.location.href = chosen.href;
        }
      }
    });

    document.addEventListener('click', (event) => {
      if (!results.contains(event.target) && event.target !== input) close();
    });

    // "/" and Ctrl/⌘+K focus the search, the way a documentation reader expects.
    document.addEventListener('keydown', (event) => {
      const typing = ['INPUT', 'TEXTAREA', 'SELECT'].includes(document.activeElement?.tagName ?? '');
      if (typing) return;
      if (event.key === '/' || ((event.ctrlKey || event.metaKey) && event.key.toLowerCase() === 'k')) {
        event.preventDefault();
        input.focus();
        input.select();
      }
    });
  };

  const start = () => {
    addCopyButtons();
    addSidebarToggle();
    trackHeadings();
    addSearch();
  };

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', start);
  } else {
    start();
  }
})();
