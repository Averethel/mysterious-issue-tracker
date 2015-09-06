# Mysterious Issue Tracker API

## List issues
### GET /api/v1/issues
#### Example
```
  resp = conn.get("/api/v1/issues")
```

```
  resp.status
  => 200
```

```
  resp.body
  =>  {
        "data":[
          {
            "id":"1",
            "type":"issues",
            "attributes":{
              "title":"Test issue",
              "description":"Just testing",
              "priority":"minor",
              "status":"open",
              "created_at":"2015-09-06T15:53:51.594Z",
              "updated_at":"2015-09-06T15:53:51.594Z"
            }
          },
          {
            "id":"2",
            "type":"issues",
            "attributes":{
              "title":"Test issue 2",
              "description":"Just testing",
              "priority":"major",
              "status":"open",
              "created_at":"2015-09-06T16:02:25.640Z",
              "updated_at":"2015-09-06T16:02:25.640Z"
            }
          }
        ],
        "meta":{
          "total":2
        }
      }
```

## Get single issue
### GET /api/v1/issues/:id
#### Example
```
  resp = conn.get("/api/v1/issues/1")
```

```
  resp.status
  => 200
```

```
  resp.body
  =>  {
        "data":{
          "id":"1",
          "type":"issues",
          "attributes":{
            "title":"Test issue",
            "description":"Just testing",
            "priority":"minor",
            "status":"open",
            "created_at":"2015-09-06T15:53:51.594Z",
            "updated_at":"2015-09-06T15:53:51.594Z"
          }
        }
      }
```

## Create an issue
### POST /api/v1/issues
#### body parameters:
  * `issue[tite]`: STRING, required
  * `issue[description]`: STRING, required
  * `issue[priority]`: STRING, required, [minor, major, critical, blocker]

#### Examples
```
  resp = conn.post("/api/v1/issues/", {issue: {title: 'No comments', description: 'Can\'t comment issues', priority: 'critical'}})
```

```
  resp.status
  => 200
```

```
  resp.body
  =>  {
        "data":{
          "id":"2",
          "type":"issues",
          "attributes":{
            "title":"No comments",
            "description":"Can't comment issues",
            "priority":"critical",
            "status":"open",
            "created_at":"2015-09-06T15:53:51.594Z",
            "updated_at":"2015-09-06T15:53:51.594Z"
          }
        }
      }
```

```
  resp = conn.post("/api/v1/issues/", {issue: {title: 'No comments'})
```
```
  resp.status
  => 422
```
```
  resp.body
  => {
        "errors":[
          {
            "status":"422",
            "title":"Invalid description",
            "detail":"can't be blank"
          },
          {
            "status":"422",
            "title":"Invalid priority",
            "detail":"can't be blank"
          }
        ]
      }
```

## Update an issue
### PATCH /api/v1/issues/:id
#### body parameters:
  * `issue[tite]`: STRING
  * `issue[description]`: STRING
  * `issue[priority]`: STRING, [minor, major, critical, blocker]
  * `issue[status]`: STRING, [open, in_progress, fixed, rejected]

#### Examples
```
  resp = conn.patch("/api/v1/issues/1", {issue: {title: 'No comments', description: 'Can\'t comment issues', priority: 'major'}})
```
```
  resp.status
  => 422
```
```
  resp.body
  =>  {
        "data":{
          "id":"1",
          "type":"issues",
          "attributes":{
            "title":"No comments",
            "description":"Can't comment issues",
            "priority":"major",
            "status":"open",
            "created_at":"2015-09-06T15:53:51.594Z",
            "updated_at":"2015-09-06T15:53:51.594Z"
          }
        }
      }
```
```
  resp = conn.patch("/api/v1/issues/1", {issue: {title: ''})
```
```
  resp.status
  => 422
```
```
  resp.body
  => {
       "errors":[
         {
           "status":"422",
           "title":"Invalid title",
           "detail":"can't be blank"
         }
       ]
     }
```
