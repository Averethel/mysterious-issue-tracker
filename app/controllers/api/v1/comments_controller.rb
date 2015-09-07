class Api::V1::CommentsController < ApplicationController
  before_action :set_issue, only: [:index]
  before_action :set_comment, only: [:show]
  ## Returns a list of comments for given issue
  #
  # GET /api/v1/issues/:issue_id/comments
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
  #                    "id": "2"
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
  #                    "id": "2"
  #                  }
  #                }
  #              }
  #            }
  #          ],
  #          "meta": {
  #            "total": 2
  #          }
  #        }
  def index
    @comments = @issue.comments

    render json: @comments, meta: { total: @comments.count }
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
  #             "body": "foo"
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
  def show
    render json: @comment
  end
  private

  def set_issue
    @issue = Issue.find(params[:issue_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end
end
