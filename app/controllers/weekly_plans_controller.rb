class WeeklyPlansController < ApplicationController
  before_action :check_logged_in
  before_action :set_goal, only: [:edit, :update, :destroy]

  def index
    @goals = current_user.goals.where(status: '取組中')
  end

  def edit
    # @test = Goal.joins(problems: :solutions)
    # @test2 = Solution.joins(problems: :goals)
    # @test3 = Goal.includes(:problems, :solutions)
    # @test4 = Solution.includes(:goals, :problems)

    @problems = @goal.problems
    @problems.each do |problem|
      @solutions = problem.solutions
    end
    @working_solution = @solutions.where(status: '取組中')
  end

  def update
    if @goal.update(weekly_plan_params)
      redirect_to weekly_plans_path, notice: '変更が保存されました'
    else
      render :edit
    end
  end

  private
  def weekly_plan_params
    params.require(:goal).permit(:_destroy, :id,
                                 problems_attributes: [:status, :_destroy, :id,
                                 solutions_attributes:[:status, :_destroy, :id,
                                 tasks_attributes:    [:status, :_destroy, :id]]])
  end

  def set_goal
    @goal = Goal.find(params[:id])
  end
end
