class Api::V1::CommentsController < ApplicationController
  before_action :set_issue, only: [:index, :create]
  before_action :set_comment, only: [:show, :update, :destroy]

  ## Returns a list of comments for given issue
  #
  # GET /api/v1/issues/:issue_id/comments
  # 
  # parameters:
  #   page[size]: INTEGER
  #   page[number]: INTEGER
  #
  # = Example
  #
  #   resp = conn.get("/api/v1/issues/1/comments")
  #
  #   resp.status
  #   => 200
  #
  #   resp.body
  #   =>  {
  #          "data": [
  #            {
  #              "id": "1",
  #              "type": "comments",
  #              "attributes": {
  #                "body": "This is important"
  #              },
  #              "relationships": {
  #                "issue": {
  #                  "data": {
  #                    "type": "issues",
  #                    "id": "1"
  #                  }
  #                }
  #              }
  #            },
  #            {
  #              "id": "2",
  #              "type": "comments",
  #              "attributes": {
  #                "body": "+1"
  #              },
  #              "relationships": {
  #                "issue": {
  #                  "data": {
  #                    "type": "issues",
  #                    "id": "1"
  #                  }
  #                }
  #              }
  #            }
  #          ],
  #          "links": {
  #            "self": "http://mysterious-issue-tracker.dev/api/v1/issues/1/comments?page%5Bnumber%5D=1&page%5Bsize%5D=2",
  #            "next": "http://mysterious-issue-tracker.dev/api/v1/issues/1/comments?page%5Bnumber%5D=2&page%5Bsize%5D=2",
  #            "last": "http://mysterious-issue-tracker.dev/api/v1/issues/1/comments?page%5Bnumber%5D=2&page%5Bsize%5D=2"
  #          },
  #          "meta": {
  #            "total": 4,
  #             "current_page": 1,
  #             "on_page": 2,
  #             "total_pages": 2
  #          }
  #        }
  def index
    @comments = @issue.comments.page(params[:page][:number]).per(params[:page][:size])

    render json: @comments, meta: {
      total: @issue.comments.count,
      current_page: @comments.current_page,
      on_page: @comments.size,
      total_pages: @comments.total_pages
    }
  end

  ## Returns single comment
  #
  # GET /api/v1/comments/:id
  #
  # = Example
  #
  #   resp = conn.get("/api/v1/comments/1")
  #
  #   resp.status
  #   => 200
  #
  #   resp.body
  #   =>  {
  #         "data": {
  #           "id": "1",
  #           "type": "comments",
  #           "attributes": {
  #             "body": "+1"
  #           },
  #           "relationships": {
  #             "issue": {
  #               "data": {
  #                 "type": "issues",
  #                 "id": "1"
  #               }
  #             }
  #           }
  #         }
  #       }
  def show
    render json: @comment
  end

  ## Creates a comment for given issue
  #
  # POST /api/v1/issues/:issue_id/comments
  #
  # body parameters:
  #   comment[body]: STRING
  #
  # = Examples
  #
  #   resp = conn.post("/api/v1/issues/1/comments", {comment: {body: '+1'}})
  #
  #   resp.status
  #   => 200
  #
  #   resp.body
  #   =>  {
  #         "data": {
  #           "id": "1",
  #           "type": "comments",
  #           "attributes": {
  #             "body": "+1"
  #           },
  #           "relationships": {
  #             "issue": {
  #               "data": {
  #                 "type": "issues",
  #                 "id": "1"
  #               }
  #             }
  #           }
  #         }
  #       }
  #
  #   resp = conn.post("/api/v1/issues/1/comments", {comment: {body: ''})
  #
  #   resp.status
  #   => 422
  #
  #   resp.body
  #   => {
  #        "errors":[
  #          {
  #            "status":"422",
  #            "title":"Invalid body",
  #            "detail":"can't be blank"
  #          }
  #        ]
  #      }
  def create
    @comment = @issue.comments.build(comment_params)

    if @comment.save
      render json: @comment, status: :created, location: api_v1_comment_url(@comment)
    else
      validation_errors(@comment.errors)
    end
  end

  ## Updates a comment
  #
  # PATCH /api/v1/comments/:id
  #
  # body parameters:
  #   comment[body]: STRING
  #
  # = Examples
  #
  #   resp = conn.patch("/api/v1/comments/1", {comment: {body: '+1'}})
  #
  #   resp.status
  #   => 200
  #
  #   resp.body
  #   =>  {
  #         "data": {
  #           "id": "1",
  #           "type": "comments",
  #           "attributes": {
  #             "body": "+1"
  #           },
  #           "relationships": {
  #             "issue": {
  #               "data": {
  #                 "type": "issues",
  #                 "id": "2"
  #               }
  #             }
  #           }
  #         }
  #       }
  #
  #   resp = conn.patch("/api/v1/comments/1", {comment: {body: ''})
  #
  #   resp.status
  #   => 422
  #
  #   resp.body
  #   => {
  #        "errors":[
  #          {
  #            "status":"422",
  #            "title":"Invalid body",
  #            "detail":"can't be blank"
  #          }
  #        ]
  #      }
  def update
    if @comment.update_attributes(comment_params)
      render json: @comment
    else
      validation_errors(@comment.errors)
    end
  end

  ## Deletes a comment
  #
  # DELETE /comments/:id
  #
  # = Examples
  #
  #   resp = conn.delete("/api/v1/comments/1")
  #
  #   resp.status
  #   => 204
  def destroy
    @comment.destroy

    head :no_content
  end

  private

  def set_issue
    @issue = Issue.find(params[:issue_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
