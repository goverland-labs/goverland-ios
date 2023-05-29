import json
from mitmproxy import http
import time


def request(flow: http.HTTPFlow) -> None:
    time.sleep(1)
    return
    # if flow.request.pretty_url.startswith(
    #     "https://inbox.staging.goverland.xyz/dao/top"
    # ):
    #     with open("./proxy/top_daos.json") as f:
    #         data = json.load(f)
    #     flow.response = http.Response.make(
    #         200,
    #         json.dumps(data, indent=4, sort_keys=False),  # (optional) content
    #         {"Content-Type": "application/json"},  # (optional) headers
    #     )
    #     return
