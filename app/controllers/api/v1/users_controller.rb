class Api::V1::UsersController < ApplicationController
  ## Lists users
  #
  # GET /api/v1/users
  # parameters:
  #   page[size]: INTEGER
  #   page[number]: INTEGER
  #
  # = Example
  #
  #   resp = conn.get("/api/v1/users")
  #
  #   resp.status
  #   => 200
  #
  #   resp.body
  #   => {
  #     "data": [
  #       {
  #         "id": "1",
  #         "type": "users",
  #         "attributes": {
  #           "username": "test",
  #           "name": "Test",
  #           "surname": "Testy",
  #           "created_at": "2015-09-08T09:04:51.520Z",
  #           "updated_at": "2015-09-08T09:04:51.520Z"
  #         }
  #       },
  #       {
  #         "id": "2",
  #         "type": "users",
  #         "attributes": {
  #           "username": "averethel",
  #           "name": null,
  #           "surname": null,
  #           "created_at": "2015-09-08T09:05:18.438Z",
  #           "updated_at": "2015-09-08T09:05:18.438Z"
  #         }
  #       }
  #     ],
  #     "links": {
  #       "self": "http://mysterious-issue-tracker.dev/api/v1/users?page%5Bnumber%5D=1&page%5Bsize%5D=2",
  #       "next": "http://mysterious-issue-tracker.dev/api/v1/users?page%5Bnumber%5D=2&page%5Bsize%5D=2",
  #       "last": "http://mysterious-issue-tracker.dev/api/v1/users?page%5Bnumber%5D=2&page%5Bsize%5D=2"
  #     },
  #     "meta": {
  #       "total": 3,
  #       "current_page": 1,
  #       "on_page": 2,
  #       "total_pages": 2
  #     }
  #   }
  def index
    @users = User.page(params[:page][:number]).per(params[:page][:size])

    render json: @users, meta: {
      total: User.count,
      current_page: @users.current_page,
      on_page: @users.size,
      total_pages: @users.total_pages
    }
  end
end
