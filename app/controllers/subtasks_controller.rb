class SubtasksController < ApplicationController
  def create
    subtask = Subtask.new(params[:subtask])
    
    if subtask.save()
      respond_to do |format|
        format.json { render json: subtask }
      end
    else
      respond_to do |format|
        format.json { render json: subtask.errors, status: :unprocessable_entity}
      end
    end
  end

  def update
    subtask = Subtask.find(params[:id])
    if subtask.update_attributes!(params[:subtask])
      respond_to do |format|
        format.json { render json: subtask }
      end
    else
      respond_to do |format|
        format.json { render json: subtask.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /boards/1
  # DELETE /boards/1.json
  def destroy
    @subtask = Subtask.find(params[:id])
    @subtask.destroy

    respond_to do |format|
      #format.html { redirect_to boards_url }
      format.json { head :no_content }
    end
  end
end
