A package for creating API requests in the form of a chain.

## Features

- Optional use of an access token

## Getting started

To work with the package, you need to use the Form API class, which provides the methods of the chain.

First step:
Init RequesterAPI 
```
RequesterAPI.init(domain, accessToken, errorListener?)
```

Second step:
Add to chain your route
```
.route(String route)
```

Add body to your request if necessary
```
.setBody(Map body)
```

Add params to your request if necessary
```
.setParams(String)
```

Third step:
Send request
```
.get()
.post()
.put()
.delete()
```

If you want to look at the final query, you can output it
```
.print()
```

## Usage

Create an object and add route, and then call the request
- From this example: 'https://example.com/user/profile"
```
void routeAndGet() {
  RequesterAPI api = RequesterAPI.init(domain: 'https://example.com', userToken: 'asj88dfmya79yf72qtmftg2n8t6');
  api.route('user/profile').get();
}
```

You can add the request body to the chain
- From this example: 'https://example.com/user/profile"
```
void routeAndBodyAndPost() {
  RequesterAPI api = RequesterAPI.init(domain: 'https://example.com', userToken: 'asj88dfmya79yf72qtmftg2n8t6');
  api.route('user/profile')
    .setBody({
      "username":"Shoshi",
      "city":"Fukuoka"
    }).post();
}
```

And if you need params, then add them
- From this example: 'https://example.com/user/profile"
```
void routeAndParamsAndPost() {
  RequesterAPI api = RequesterAPI.init(domain: 'https://example.com', userToken: 'asj88dfmya79yf72qtmftg2n8t6');
  api.route('user/profile')
    .setParams('username="Shoshi"&city="Tokyo"')
    .post();
}
```

Since we have a chain, you can add as many routes as you want
- From this example: 'https://example.com/user/profile/settings?theme="dark"
```
void routeAndParamsAndPut() {
  RequesterAPI api = RequesterAPI.init(domain: 'https://example.com', userToken: 'asj88dfmya79yf72qtmftg2n8t6');
  api.route('user/profile').route('settings')
    .setParams('theme="dark"')
    .put();
}
```

If necessary, you can add both body and params
- From this example: 'https://example.com/user/profile/settings?theme="dark"
```
void routeAndParamsAndBodyAndPut() {
  RequesterAPI api = RequesterAPI.init(domain: 'https://example.com', userToken: 'asj88dfmya79yf72qtmftg2n8t6');
  api.route('user/profile').route('settings')
    .setParams('theme="dark"')
    .setBody({
      "id":"a89yn79a678at8fa86021fawf"
    })
    .put();
}
```

If you don't want to create an object, you can use the constructor in the chain
- From this example: 'https://example.com/user/profile/settings?theme="dark"
```
void InitAndRouteAndParamsAndPut() {
  // RequesterAPI api = ;
  RequesterAPI.init(domain: 'https://example.com', userToken: 'asj88dfmya79yf72qtmftg2n8t6')
    .route('user/profile').route('settings')
    .setParams('theme="dark"')
    .put();
}
```