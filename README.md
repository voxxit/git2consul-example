### HOW-TO: Consul Key/Values from GitHub

In this example, we will use a Docker image running git2consul on ECS to automatically replicate key/values to multiple datacenters automatically when it changes occur on the respective branches.

First, save the following to `example.json`:

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
  -p 8600:53/udp \
  gliderlabs/consul-server:latest \
    -bootstrap
```

Then, you can pull & run the Docker image:

```
docker pull voxxit/git2consul:latest

docker run \
  --rm \
  --link consul:consul
  --env CONSUL_ENDPOINT=consul \
  voxxit/git2consul:latest
```

And, voila!

```
{"name":"git2consul","hostname":"docker","pid":1,"level":30,"msg":"git2consul is running","time":"2016-05-03T13:15:16.069Z","v":0}
{"name":"git2consul","hostname":"docker","pid":1,"level":30,"msg":"Initting repo orders","time":"2016-05-03T13:15:16.073Z","v":0}
{"name":"git2consul","hostname":"docker","pid":1,"level":30,"msg":"Initting branch /tmp/orders /tmp/orders/production","time":"2016-05-03T13:15:16.073Z","v":0}
{"name":"git2consul","hostname":"docker","pid":1,"level":30,"msg":"Initting branch /tmp/orders /tmp/orders/staging","time":"2016-05-03T13:15:16.074Z","v":0}
{"name":"git2consul","hostname":"docker","pid":1,"level":40,"msg":"Purging branch cache /tmp/orders/production for branch production in repo orders","time":"2016-05-03T13:15:16.074Z","v":0}
{"name":"git2consul","hostname":"docker","pid":1,"level":40,"msg":"Purging branch cache /tmp/orders/staging for branch staging in repo orders","time":"2016-05-03T13:15:16.075Z","v":0}
{"name":"git2consul","hostname":"docker","pid":1,"level":30,"msg":"Initialized branch production from orders","time":"2016-05-03T13:15:17.052Z","v":0}
{"name":"git2consul","hostname":"docker","pid":1,"level":30,"msg":"Initialized branch staging from orders","time":"2016-05-03T13:15:17.055Z","v":0}
{"name":"git2consul","hostname":"docker","pid":1,"level":30,"msg":"Loaded repo orders","time":"2016-05-03T13:15:17.057Z","v":0}
```

**NOTE:** Pulls from https://github.com/voxxit/git2consul-example!
