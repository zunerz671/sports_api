class SportsController < ApplicationController
  before_action :authorize_request, only: [ :create ]

  def index
    sports = Sport.all

    render json: sports
  end

  def create
    sport = Sport.new(
      name: params[:name],
      players: params[:players]
    )
    if sport.save
      render json: { message: "Sport created successfully" }, status: :created
    else
      render json: { errors: sport.errors.full_message }, status: :unprocessable_entity
    end
  end
end
