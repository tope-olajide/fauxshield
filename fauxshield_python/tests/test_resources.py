"""Parity with the API contract: nothing missing, nothing invented, right keys.

The contract in ``fauxshield_contract/contract/api_contract.json`` is extracted
from the server's generated Dart client, so comparing the generated Python
resources against it is a real check and not a check of one file against itself.
"""

import json
import re
import unittest
from pathlib import Path

from fauxshield import FauxShieldClient

CONTRACT_PATH = (
    Path(__file__).resolve().parent.parent.parent
    / "fauxshield_contract"
    / "contract"
    / "api_contract.json"
)


def contract():
    return json.loads(CONTRACT_PATH.read_text(encoding="utf-8"))


def snake(name):
    first = re.sub(r"(.)([A-Z][a-z]+)", r"\1_\2", name)
    return re.sub(r"([a-z0-9])([A-Z])", r"\1_\2", first).lower()


class RecordedTransport:
    """Answers each call with an empty success and keeps what it was asked."""

    def __init__(self):
        self.calls = []

    def call(self, endpoint, method, params):
        self.calls.append({"endpoint": endpoint, "method": method, "params": params})
        return []


class GivenTheGeneratedResources(unittest.TestCase):
    def setUp(self):
        self.transport = RecordedTransport()
        self.client = FauxShieldClient(api_key="fs_live_x", transport=self.transport)
        self.contract = contract()

    def test_every_contract_method_has_a_python_method(self):
        missing = []
        for endpoint in self.contract["endpoints"]:
            resource = getattr(self.client, snake(endpoint["name"]), None)
            self.assertIsNotNone(resource, "no resource for {}".format(endpoint["name"]))
            for method in endpoint["methods"]:
                if not hasattr(resource, snake(method["name"])):
                    missing.append("{}.{}".format(endpoint["name"], method["name"]))
        self.assertEqual(missing, [], "methods missing from the Python SDK")

    def test_no_python_method_is_missing_from_the_contract(self):
        for endpoint in self.contract["endpoints"]:
            resource = getattr(self.client, snake(endpoint["name"]))
            known = {snake(method["name"]) for method in endpoint["methods"]}
            for name in vars(type(resource)):
                if name.startswith("_"):
                    continue
                self.assertIn(
                    name,
                    known,
                    "{}.{} is in the Python SDK but not in the API".format(endpoint["name"], name),
                )

    def test_every_model_in_the_contract_is_generated(self):
        from fauxshield.generated import models

        for model in self.contract["models"]:
            self.assertTrue(hasattr(models, model["name"]), "missing model: {}".format(model["name"]))
        for value in self.contract["enums"]:
            self.assertTrue(hasattr(models, value["name"]), "missing enum: {}".format(value["name"]))

    def test_an_enum_carries_the_wire_values(self):
        from fauxshield.generated.models import AlertStatus

        self.assertEqual(AlertStatus.OPEN.value, "open")

    def test_arguments_are_sent_with_the_wire_names(self):
        self.client.product.list(include_archived=False, search="coffee")
        call = self.transport.calls[-1]
        self.assertEqual(call["endpoint"], "product")
        self.assertEqual(call["method"], "list")
        self.assertEqual(call["params"]["includeArchived"], False)
        self.assertEqual(call["params"]["search"], "coffee")

    def test_a_required_argument_is_required(self):
        with self.assertRaises(TypeError):
            self.client.product.get()


if __name__ == "__main__":
    unittest.main()
