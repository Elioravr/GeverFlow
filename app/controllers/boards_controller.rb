class BoardsController < ApplicationController
  # GET /boards
  # GET /boards.json
  def index
    @boards = Board.all
    authorize! :see_all, @boards

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @boards }
    end
  end

  # GET /boards/1
  # GET /boards/1.json
  def show
    @is_board = true
    @board = Board.find(params[:id])
    authorize! :watch, @board
    @tasks = @board.tasks.select('tasks.*, users.username').joins('LEFT OUTER JOIN users ON users.id = tasks.user_id')

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @board }
    end
  end

  # GET /boards/new
  # GET /boards/new.json
  def new
    @board = Board.new
    authorize! :create, @board

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @board }
    end
  end

  # GET /boards/1/edit
  def edit
    @board = Board.find(params[:id])
    authorize! :edit, @board
  end

  # POST /boards
  # POST /boards.json
  def create
    @board = Board.new(params[:board])
    authorize! :create, @board

    respond_to do |format|
      if @board.save
        format.html { redirect_to boards_path, notice: 'Board was successfully created.' }
        format.json { render json: @board, status: :created, location: @board }
      else
        format.html { render action: "new" }
        format.json { render json: @board.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /boards/1
  # PUT /boards/1.json
  def update
    @board = Board.find(params[:id])
    authorize! :update, @board

    respond_to do |format|
      if @board.update_attributes(params[:board])
        format.html { redirect_to boards_path, notice: 'Board was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @board.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /boards/1
  # DELETE /boards/1.json
  def destroy
    @board = Board.find(params[:id])
    authorize! :delete, @board
    @board.destroy

    respond_to do |format|
      format.html { redirect_to boards_url }
      format.json { head :no_content }
    end
  end
end
