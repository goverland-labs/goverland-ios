# goverland-ios

**Follow your favorite DAOs and never miss updates!**

## Configuration

### For contributors only
Add a git hook that automatically adds the issue number mentioned in a branch name to a commit message.
```
$> bin/bootstrap.sh
```

## mitmproxy
For a better development experience, we use [mitmproxy](https://mitmproxy.org/) with convenience methods to simulate backend errors and to work with local mocks.

```
mitmdump -s proxy/mocks.py
```
