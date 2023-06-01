import json
from mitmproxy import http
import time

counter = 0


def request(flow: http.HTTPFlow) -> None:
    global counter
    counter += 1
    time.sleep(2)
    if counter % 2 == 0:
        time.sleep(3)
    # if counter % 2 == 0:
    #     flow.response = http.Response.make(
    #         404,
    #         json.dumps(""),  # (optional) content
    #         {"Content-Type": "application/json"},  # (optional) headers
    #     )

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
