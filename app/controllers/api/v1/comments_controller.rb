class Api::V1::CommentsController < ApplicationController
  before_action :set_issue, only: [:index]
  ## Returns a list of comments for given issue
  #
  # GET /api/v1/issues/1/comments
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
  private

  def set_issue
    @issue = Issue.find(params[:issue_id])
  end
end
