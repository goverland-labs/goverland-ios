# goverland-ios

**Follow your favorite DAOs and never miss updates!**

## Configuration
Add Firebase files to the `Goverland/Analytics/Firebase` folder for DEV and PROD configurations.

## mitmproxy
For a better development experience, we use [mitmproxy](https://mitmproxy.org/) with convenience methods to simulate backend errors and to work with local mocks.

```
mitmdump -s proxy/mocks.py
```
