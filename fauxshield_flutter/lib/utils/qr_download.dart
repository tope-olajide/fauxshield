// File download helpers, routed to the right platform implementation:
// an anchor click on the web, a file write on desktop/mobile.
export 'qr_download_io.dart'
    if (dart.library.js_interop) 'qr_download_web.dart';
