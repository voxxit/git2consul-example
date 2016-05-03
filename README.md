### HOW-TO: Consul Key/Values from GitHub

In this example, we will use a Docker image running git2consul to automatically replicate key/values stored in the [production](https://github.com/voxxit/git2consul-example/tree/production), [staging](https://github.com/voxxit/git2consul-example/tree/staging) and [development](https://github.com/voxxit/git2consul-example/tree/development) branches of this example repo to Consul automatically when it changes occur on the respective branches.

---

Here is the contents of `app.json` - [our configuration file for `git2consul`](https://github.com/Cimpress-MCP/git2consul#configuration):

```
{
  "version": "1.0",
  "repos" : [
    {
      "name" : "app",
      "expand_keys": true,
      "url" : "https://github.com/voxxit/git2consul-example.git",
      "branches" : [
        "production",
        "staging",
        "development"
      ],
      "hooks": [
        {
          "type" : "github",
          "port" : "8888",
          "url" : "/github"
        }
      ]
    }
  ]
}
```

If you don't have an instance of [consul](https://consul.io) locally on your machine to test this out, use this command to start one up:

```
docker pull gliderlabs/consul-server:latest

docker run \
  --detach \
  --name consul \
  --host consul \
  -p 8400:8400 \
  -p 8500:8500 \
  -p 8600:8600/udp \
  gliderlabs/consul-server:latest \
    -bootstrap
```

Then, build the Docker image containing the configuration file from the `Dockerfile`, and run it:

```
docker build -t voxxit/git2consul .

docker run \
  --rm \
  --link consul:consul
  --env CONSUL_ENDPOINT=consul \
  voxxit/git2consul
```

You should see output similar to the following:

```
{"name":"git2consul","hostname":"136480d59a01","pid":1,"level":30,"msg":"Adding /etc/git2consul.json to KV git2consul/config as: \n{\n  \"version\": \"1.0\",\n  \"repos\" : [\n    {\n      \"name\" : \"app\",\n      \"expand_keys\": true,\n      \"url\" : \"https://github.com/voxxit/git2consul-example.git\",\n      \"branches\" : [\n        \"production\",\n        \"staging\",\n        \"development\"\n      ],\n      \"hooks\": [\n        {\n          \"type\" : \"github\",\n          \"port\" : \"8888\",\n          \"url\" : \"/github\"\n        }\n      ]\n    }\n  ]\n}\n","time":"2016-05-03T13:42:54.510Z","v":0}
{"name":"git2consul","hostname":"136480d59a01","pid":1,"level":30,"msg":"git2consul is running","time":"2016-05-03T13:42:54.719Z","v":0}
{"name":"git2consul","hostname":"136480d59a01","pid":1,"level":30,"msg":"Initting repo app","time":"2016-05-03T13:42:54.725Z","v":0}
{"name":"git2consul","hostname":"136480d59a01","pid":1,"level":30,"msg":"Initting branch /tmp/app /tmp/app/production","time":"2016-05-03T13:42:54.725Z","v":0}
{"name":"git2consul","hostname":"136480d59a01","pid":1,"level":30,"msg":"Initting branch /tmp/app /tmp/app/staging","time":"2016-05-03T13:42:54.726Z","v":0}
{"name":"git2consul","hostname":"136480d59a01","pid":1,"level":30,"msg":"Initting branch /tmp/app /tmp/app/development","time":"2016-05-03T13:42:54.726Z","v":0}
{"name":"git2consul","hostname":"136480d59a01","pid":1,"level":40,"msg":"Purging branch cache /tmp/app/production for branch production in repo app","time":"2016-05-03T13:42:54.727Z","v":0}
{"name":"git2consul","hostname":"136480d59a01","pid":1,"level":40,"msg":"Purging branch cache /tmp/app/staging for branch staging in repo app","time":"2016-05-03T13:42:54.728Z","v":0}
{"name":"git2consul","hostname":"136480d59a01","pid":1,"level":40,"msg":"Purging branch cache /tmp/app/development for branch development in repo app","time":"2016-05-03T13:42:54.728Z","v":0}
{"name":"git2consul","hostname":"136480d59a01","pid":1,"level":30,"msg":"Initialized branch staging from app","time":"2016-05-03T13:42:55.398Z","v":0}
{"name":"git2consul","hostname":"136480d59a01","pid":1,"level":30,"msg":"Initialized branch development from app","time":"2016-05-03T13:42:55.401Z","v":0}
{"name":"git2consul","hostname":"136480d59a01","pid":1,"level":30,"msg":"Initialized branch production from app","time":"2016-05-03T13:42:55.418Z","v":0}
{"name":"git2consul","hostname":"136480d59a01","pid":1,"level":30,"msg":"github listener initialized at http://localhost:8888/github","time":"2016-05-03T13:42:55.473Z","v":0}
{"name":"git2consul","hostname":"136480d59a01","pid":1,"level":30,"msg":"Loaded repo app","time":"2016-05-03T13:42:55.474Z","v":0}
```
