# Mysterious Issue Tracker API

## Authentication method
HTTP Basic Auth (ommited in examples)

## Authorization
Role base system with following permissions
### guest
#### Issues
  * read

#### Comments
  * read

#### Users
  * me
  * read
  * create

### user
#### Issue
  * read
  * create
  * take
  * free
    * only if assignee
  * edit
    * status if assignee
    * full if creator
  * destroy
    * only if creator

#### Comments
  * read
  * create
  * edit
    * only if creator
  * destroy
    * only if creator

#### Users
  * me
  * read
  * create
  * edit
    * only self
  * destroy
    * only self

### admin
#### Issues
  * read
  * create
  * edit
  * destroy

#### Comments
  * read
  * create
  * edit
  * destroy

#### Users
  * me
  * read
  * create
  * edit
  * destroy

## List all users
### GET /api/v1/users
#### parameters:
  * pagination
    * `page[size]`: INTEGER
    * `page[number]`: INTEGER
  * filtering
    * `filters[username]`: STRING - wildcard match
    * `filters[id]`: [INTEGER] - inclusion math

#### Example
```
  resp = conn.get("/api/v1/users")
```

```
  resp.status
  => 200
```

```
  resp.body
  => {
    "data": [
      {
        "id": "1",
        "type": "users",
        "attributes": {
          "username": "test",
          "name": "Test",
          "surname": "Testy",
          "role": "user",
          "created_at": "2015-09-08T09:04:51.520Z",
          "updated_at": "2015-09-08T09:04:51.520Z"
        },
        "relationships": {
          "issues": {
            "data": [
              {
                "id": "2",
                "type": "issues"
              }
            ]
          },
          "assigned_issues": {
            "data": [
              {
                "id": "1",
                "type": "issues"
              }
            ]
          },
          "comments": {
            "data": []
          }
        }
      },
      {
        "id": "2",
        "type": "users",
        "attributes": {
          "username": "averethel",
          "name": null,
          "surname": null,
          "role": "user",
          "created_at": "2015-09-08T09:05:18.438Z",
          "updated_at": "2015-09-08T09:05:18.438Z"
        },
        "relationships": {
          "issues": {
            "data": [
              {
                "id": "1",
                "type": "issues"
              }
            ]
          },
          "assigned_issues": {
            "data": [
              {
                "id": "2",
                "type": "issues"
              }
            ]
          },
          "comments": {
            "data": [
              {
                "id": "1",
                "type": "comments"
              }
            ]
          }
        }
      }
    ],
    "links": {
      "self": "http://mysterious-issue-tracker.dev/api/v1/users?page%5Bnumber%5D=1&page%5Bsize%5D=2",
      "next": "http://mysterious-issue-tracker.dev/api/v1/users?page%5Bnumber%5D=2&page%5Bsize%5D=2",
      "last": "http://mysterious-issue-tracker.dev/api/v1/users?page%5Bnumber%5D=2&page%5Bsize%5D=2"
    },
    "meta": {
      "total": 3,
      "current_page": 1,
      "on_page": 2,
      "total_pages": 2
    }
  }
```

## Get current user
### GET /api/v1/users/me
#### Example
```
  resp = conn.get("/api/v1/users/me")
```

```
  resp.status
  => 200
```

```
  resp.body
  =>  {
        "id": "1",
        "type": "users",
        "attributes": {
          "username": "test",
          "name": "Test",
          "surname": "Testy",
          "role": "user",
          "created_at": "2015-09-08T09:04:51.520Z",
          "updated_at": "2015-09-08T09:04:51.520Z"
        },
        "relationships": {
          "issues": {
            "data": [
              {
                "id": "2",
                "type": "issues"
              }
            ]
          },
          "assigned_issues": {
            "data": [
              {
                "id": "1",
                "type": "issues"
              }
            ]
          },
          "comments": {
            "data": []
          }
        }
      }
```


## Get single user
### GET /api/v1/users/:id
#### Example
```
  resp = conn.get("/api/v1/users/1")
```

```
  resp.status
  => 200
```

```
  resp.body
  =>  {
        "id": "1",
        "type": "users",
        "attributes": {
          "username": "test",
          "name": "Test",
          "surname": "Testy",
          "role": "user",
          "created_at": "2015-09-08T09:04:51.520Z",
          "updated_at": "2015-09-08T09:04:51.520Z"
        },
        "relationships": {
          "issues": {
            "data": [
              {
                "id": "2",
                "type": "issues"
              }
            ]
          },
          "assigned_issues": {
            "data": [
              {
                "id": "1",
                "type": "issues"
              }
            ]
          },
          "comments": {
            "data": []
          }
        }
      }
```

## Create a user
### POST /api/v1/users
#### body parameters:
  * `user[username]`: STRING, required
  * `user[password]`: STRING, required
  * `user[password_confirmation]`: STRING, required
  * `user[name]`: STRING
  * `user[surname]`: STRING
  * `user[role]`: STRING, [user, admin], as admin only

#### Examples
```
  resp = conn.post("/api/v1/users/", {user: {username: 'tester', password: 'test', password_confirmation: 'test', name: 'Test', surname: 'Testy'}})
```

```
  resp.status
  => 201
```

```
  resp.body
  =>  {
        "id": "1",
        "type": "users",
        "attributes": {
          "username": "test",
          "name": "Test",
          "surname": "Testy",
          "role": "user",
          "created_at": "2015-09-08T09:04:51.520Z",
          "updated_at": "2015-09-08T09:04:51.520Z"
        },
        "relationships": {
          "issues": {
            "data": []
          },
          "assigned_issues": {
            "data": []
          },
          "comments": {
            "data": []
          }
        }
      }
```

```
  resp = conn.post("/api/v1/users/", {user: {username: 'tester'})
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
            "title":"Invalid password",
            "detail":"can't be blank"
          }
        ]
      }
```

## Update a user
### PATCH /api/v1/users/:id
#### body parameters:
  * `user[username]`: STRING
  * `user[password]`: STRING
  * `user[password_confirmation]`: STRING
  * `user[name]`: STRING
  * `user[surname]`: STRING
  * `user[role]`: STRING, [user, admin], as admin only

#### Examples
```
  resp = conn.patch("/api/v1/users/1", {user: {username: 'tester', password: 'test', password_confirmation: 'test', name: 'Test', surname: 'Testy'}})
```
```
  resp.status
  => 200
```
```
  resp.body
  =>  resp.body
  =>  {
        "id": "1",
        "type": "users",
        "attributes": {
          "username": "test",
          "name": "Test",
          "role": "user",
          "surname": "Testy",
          "created_at": "2015-09-08T09:04:51.520Z",
          "updated_at": "2015-09-08T09:45:51.520Z"
        },
        "relationships": {
          "issues": {
            "data": [
              {
                "id": "2",
                "type": "issues"
              }
            ]
          },
          "assigned_issues": {
            "data": [
              {
                "id": "1",
                "type": "issues"
              }
            ]
          },
          "comments": {
            "data": []
          }
        }
      }
```
```
  resp = conn.patch("/api/v1/users/1", {user: {username: ''})
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
           "title":"Invalid username",
           "detail":"can't be blank"
         }
       ]
     }
```

## Delete a user
### DELETE /api/v1/users/:id
#### Examples
```
  resp = conn.delete("/api/v1/users/1")
```
```
  resp.status
  => 204
```

## List issues
### GET /api/v1/issues
#### parameters:
  * pagination
    * `page[size]`: INTEGER
    * `page[number]`: INTEGER
  * filtering
    * `filters[title]`: STRING - wildcard match
    * `filters[description]`: STRING - wildcard match
    * `filters[id]`: [INTEGER] - inclusion math
    * `filters[priority]`: [STRING] - inclusion math
    * `filters[status]`: [STRING] - inclusion math
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
            },
            "relationships": {
              "comments": {
                "data": [
                  {
                    "type": "comments",
                    "id": "1"
                  }
                ]
              },
              "creator": {
                "data": {
                  "id": "1",
                  "type": "users"
                }
              }
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
            },
            "relationships": {
              "comments": {
                "data": []
              },
              "creator": {
                "data": {
                  "id": "2",
                  "type": "users"
                }
              }
            }
          }
        ],
        "links": {
          "self": "http://mysterious-issue-tracker.dev/api/v1/issues/1?page%5Bnumber%5D=1&page%5Bsize%5D=2",
          "next": "http://mysterious-issue-tracker.dev/api/v1/issues/1?page%5Bnumber%5D=2&page%5Bsize%5D=2",
          "last": "http://mysterious-issue-tracker.dev/api/v1/issues/1?page%5Bnumber%5D=2&page%5Bsize%5D=2"
        },
        "meta": {
          "total": 4,
           "current_page": 1,
           "on_page": 2,
           "total_pages": 2
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
          },
          "relationships": {
            "comments": {
              "data": []
            },
            "creator": {
              "data": {
                "id": "2",
                "type": "users"
              }
            }
          }
        }
      }
```

## Create an issue
### POST /api/v1/issues
#### restrictions
  must be authenticated
#### body parameters:
  * `issue[tite]`: STRING, required
  * `issue[description]`: STRING, required
  * `issue[priority]`: STRING, required, [minor, major, critical, blocker]
  * `issue[assignee_id]`: INTEGER - user id

#### Examples
```
  resp = conn.post("/api/v1/issues/", {issue: {title: 'No comments', description: 'Can\'t comment issues', priority: 'critical'}})
```

```
  resp.status
  => 201
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
          },
          "relationships": {
            "comments": {
              "data": []
            },
            "creator": {
              "data": {
                "id": "2",
                "type": "users"
              }
            }
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

## Assign the issue to current_user
### PATCH /api/v1/issues/:id/take
### Examples
```
  resp = conn.patch("/api/v1/issues/1/take")
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
            "title":"No comments",
            "description":"Can't comment issues",
            "priority":"major",
            "status":"open",
            "created_at":"2015-09-06T15:53:51.594Z",
            "updated_at":"2015-09-06T15:53:51.594Z"
          },
          "relationships": {
            "comments": {
              "data": []
            },
           "creator": {
              "data": {
                "id": "2",
                "type": "users"
              }
            },
            "assignee": {
              "data": {
                "id": "1",
                "type": "users"
              }
            }
          }
        }
      }
```

## Update an issue
### PATCH /api/v1/issues/:id
#### body parameters:
  * `issue[tite]`: STRING
  * `issue[description]`: STRING
  * `issue[priority]`: STRING, [minor, major, critical, blocker]
  * `issue[status]`: STRING, [open, in_progress, fixed, rejected]
  * `issue[assignee_id]`: INTEGER - user id

#### Examples
```
  resp = conn.patch("/api/v1/issues/1", {issue: {title: 'No comments', description: 'Can\'t comment issues', priority: 'major'}})
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
            "title":"No comments",
            "description":"Can't comment issues",
            "priority":"major",
            "status":"open",
            "created_at":"2015-09-06T15:53:51.594Z",
            "updated_at":"2015-09-06T15:53:51.594Z"
          },
          "relationships": {
            "comments": {
              "data": []
            },
            "creator": {
              "data": {
                "id": "2",
                "type": "users"
              }
            }
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

## Delete an issue
### DELETE /api/v1/issues/:id
#### Examples
```
  resp = conn.delete("/api/v1/issues/1")
```
```
  resp.status
  => 204
```

## List of comments for given issue
### GET /api/v1/issues/1/comments
#### parameters:
  * `page[size]`: INTEGER
  * `page[number]`: INTEGER

#### Example
```
  resp = conn.get("/api/v1/issues/:issue_id/comments")
```
```
  resp.status
  => 200
```
```
  resp.body
  =>  {
         "data": [
           {
             "id": "1",
             "type": "comments",
             "attributes": {
               "body": "This is important",
               "created_at": "2015-09-08T09:04:51.520Z",
               "updated_at": "2015-09-08T09:04:51.520Z"
             },
             "relationships": {
               "issue": {
                 "data": {
                   "type": "issues",
                   "id": "1"
                 }
               },
               "creator": {
                 "data": {
                   "id": "2",
                   "type": "users"
                 }
               }
             }
           },
           {
             "id": "2",
             "type": "comments",
             "attributes": {
               "body": "+1",
               "created_at": "2015-09-08T09:36:51.520Z",
               "updated_at": "2015-09-08T09:36:51.520Z"
             },
             "relationships": {
               "issue": {
                 "data": {
                   "type": "issues",
                   "id": "1"
                 }
               },
               "creator": {
                 "data": {
                   "id": "1",
                   "type": "users"
                 }
               }
             }
           }
         ],
         "links": {
           "self": "http://mysterious-issue-tracker.dev/api/v1/issues/1/comments?page%5Bnumber%5D=1&page%5Bsize%5D=2",
           "next": "http://mysterious-issue-tracker.dev/api/v1/issues/1/comments?page%5Bnumber%5D=2&page%5Bsize%5D=2",
           "last": "http://mysterious-issue-tracker.dev/api/v1/issues/1/comments?page%5Bnumber%5D=2&page%5Bsize%5D=2"
         },
         "meta": {
           "total": 4,
            "current_page": 1,
            "on_page": 2,
            "total_pages": 2
         }
       }
```

## Get single comment
### GET /api/v1/comments/:id
#### Example
```
  resp = conn.get("/api/v1/comments/1")
```
```
  resp.status
  => 200
```
```
  resp.body
  =>  {
        "data": {
          "id": "1",
          "type": "comments",
          "attributes": {
            "body": "+1",
            "created_at": "2015-09-08T09:36:51.520Z",
            "updated_at": "2015-09-08T09:36:51.520Z"
          },
          "relationships": {
            "issue": {
              "data": {
                "type": "issues",
                "id": "1"
              }
            },
            "creator": {
              "data": {
                "id": "2",
                "type": "users"
              }
            }
          }
        }
      }
```

## Comment on given issue
### POST /api/v1/issues/:issue_id/comments
#### restrictions
  must be authenticated
#### body parameters:
  * `comment[body]`: STRING

#### Examples
```
  resp = conn.post("/api/v1/issues/1/comments", {comment: {body: '+1'}})
```
```
  resp.status
  => 200
```
```
  resp.body
  =>  {
        "data": {
          "id": "1",
          "type": "comments",
          "attributes": {
            "body": "+1",
            "created_at": "2015-09-08T09:36:51.520Z",
            "updated_at": "2015-09-08T09:36:51.520Z"
          },
          "relationships": {
            "issue": {
              "data": {
                "type": "issues",
                "id": "1"
              }
            },
            "creator": {
              "data": {
                "id": "2",
                "type": "users"
              }
            }
          }
        }
      }
```
```
  resp = conn.post("/api/v1/issues/1/comments", {comment: {body: ''})
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
            "title":"Invalid body",
            "detail":"can't be blank"
          }
        ]
      }
```

## Update a comment
### PATCH /api/v1/comments/:id
#### body parameters:
* `comment[body]`: STRING

#### Examples
```
  resp = conn.patch("/api/v1/comments/1", {comment: {body: '+1'}})
```
```
  resp.status
  => 200
```
```
  resp.body
  =>  {
        "data": {
          "id": "1",
          "type": "comments",
          "attributes": {
            "body": "+1",
            "created_at": "2015-09-08T09:36:51.520Z",
            "updated_at": "2015-09-08T09:45:51.520Z"
          },
          "relationships": {
            "issue": {
              "data": {
                "type": "issues",
                "id": "1"
              }
            },
            "creator": {
              "data": {
                "id": "2",
                "type": "users"
              }
            }
          }
        }
      }
```
```
  resp = conn.patch("/api/v1/comments/1", {comment: {body: ''})
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
           "title":"Invalid body",
           "detail":"can't be blank"
         }
       ]
     }
```

## Delete a comment
### DELETE /api/v1/comments/:id
### Examples
```
  resp = conn.delete("/api/v1/comments/1")
```
```
  resp.status
  => 204
```
