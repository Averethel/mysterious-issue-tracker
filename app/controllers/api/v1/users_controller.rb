class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

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
  #         },
  #          "relationships": {
  #           "issues": {
  #             "data": [
  #               {
  #                 "id": "2",
  #                 "type": "issues"
  #               }
  #             ]
  #           },
  #          "comments": {
  #             "data": []
  #           }
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
  #         },
  #          "relationships": {
  #           "issues": {
  #             "data": [
  #               {
  #                 "id": "1",
  #                 "type": "issues"
  #               }
  #             ]
  #           },
  #          "comments": {
  #             "data": [
  #                {
  #                   "id": "1",
  #                   "type": "comments"
  #                 }
  #               ]
  #             }
  #           }
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

  ## Gets single user
  #
  # GET /api/v1/users/:id
  #
  # = Example
  #
  #   resp = conn.get("/api/v1/users/1")
  #
  #   resp.status
  #   => 200
  #
  #   resp.body
  #   =>  {
  #         "id": "1",
  #         "type": "users",
  #         "attributes": {
  #           "username": "test",
  #           "name": "Test",
  #           "surname": "Testy",
  #           "created_at": "2015-09-08T09:04:51.520Z",
  #           "updated_at": "2015-09-08T09:04:51.520Z"
  #         },
  #         "relationships": {
  #           "issues": {
  #             "data": [
  #               {
  #                 "id": "1",
  #                 "type": "issues"
  #               }
  #             ]
  #           },
  #           "comments": {
  #             "data": []
  #           }
  #         }
  #       }
  def show
    render json: @user
  end

  ## Creates a user
  #
  # POST /api/v1/users
  #
  # body parameters:
  #   user[username]: STRING, required
  #   user[password]: STRING, required
  #   user[password_confirmation]: STRING, required
  #   user[name]: STRING
  #   user[surname]: STRING
  #
  # = Examples
  #
  #   resp = conn.post("/api/v1/users/", {user: {username: 'tester', password: 'test', password_confirmation: 'test', name: 'Test', surname: 'Testy'}})
  #
  #   resp.status
  #   => 201
  #
  #   resp.body
  #   =>  {
  #         "id": "1",
  #         "type": "users",
  #         "attributes": {
  #           "username": "test",
  #           "name": "Test",
  #           "surname": "Testy",
  #           "created_at": "2015-09-08T09:04:51.520Z",
  #           "updated_at": "2015-09-08T09:04:51.520Z"
  #         },
  #         "relationships": {
  #           "issues": {
  #             "data": []
  #           },
  #           "comments": {
  #             "data": []
  #           }
  #         }
  #       }
  #
  #   resp = conn.post("/api/v1/users/", {user: {username: 'tester'})
  #   resp.status
  #   => 422
  #   resp.body
  #   => {
  #         "errors":[
  #           {
  #             "status":"422",
  #             "title":"Invalid password",
  #             "detail":"can't be blank"
  #           }
  #         ]
  #       }
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: api_v1_user_url(@user)
    else
      validation_errors(@user.errors)
    end
  end

  ## Updates a user
  #
  # PATCH /api/v1/users/:id
  # body parameters:
  #   user[username]: STRING
  #   user[password]: STRING
  #   user[password_confirmation]: STRING, required if password changed
  #   user[name]: STRING
  #   user[surname]: STRING
  #
  # = Examples
  #
  #   resp = conn.patch("/api/v1/users/1", {user: {username: 'tester', password: 'test', password_confirmation: 'test', name: 'Test', surname: 'Testy'}})
  #
  #   resp.status
  #   => 200
  #
  #   resp.body
  #   =>  {
  #         "id": "1",
  #         "type": "users",
  #         "attributes": {
  #           "username": "test",
  #           "name": "Test",
  #           "surname": "Testy",
  #           "created_at": "2015-09-08T09:04:51.520Z",
  #           "updated_at": "2015-09-08T09:45:51.520Z"
  #         },
  #         "relationships": {
  #           "issues": {
  #             "data": [
  #               {
  #                 "id": "1",
  #                 "type": "issues"
  #               }
  #             ]
  #           },
  #           "comments": {
  #             "data": []
  #           }
  #         }
  #       }
  #
  #   resp = conn.patch("/api/v1/users/1", {user: {username: ''})
  #
  #   resp.status
  #   => 422
  #
  #   resp.body
  #   => {
  #        "errors":[
  #          {
  #            "status":"422",
  #            "title":"Invalid username",
  #            "detail":"can't be blank"
  #          }
  #        ]
  #      }
  def update
    if @user.update(user_params)
      render json: @user
    else
      validation_errors(@user.errors)
    end
  end

  ## Deletes a user
  #
  # DELETE /api/v1/users/:id
  #
  # = Examples
  #
  #   resp = conn.delete("/api/v1/users/1")
  #
  #   resp.status
  #   => 204
  def destroy
    @user.destroy

    head :no_content
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :name, :surname, :password, :password_confirmation)
  end
end
