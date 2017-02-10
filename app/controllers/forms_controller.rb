class FormsController < InheritedResources::Base
  before_action :set_form, only: [:show, :edit, :update, :destroy]
  layout false

  def index
    forms = Form.all
    respond_to do |format|
      format.json { render json: forms}
    end
  end

  def show
  end

  # GET /activities/new
  def new
    @form = Form.new
  end

  # GET /activities/1/edit
  def edit
  end

  # POST /activities
  # POST /activities.json
  def create
    @form = Form.new(form_params)
    respond_to do |format|
      if @form.save
        format.html { redirect_to @form, notice: 'La actividad fue creada éxitosamente. ' }
        format.json { render :show, status: :created, location: @form }
      else
        format.html { render :new }
        format.json { render json: @form.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activities/1
  # PATCH/PUT /activities/1.json
  def update
    respond_to do |format|
      if @form.update(form_params)
        format.html { redirect_to @form, notice: 'La actividad fue modificada éxitosamente. ' }
        format.json { render :show, status: :ok, location: @form }
      else
        format.html { render :edit }
        format.json { render json: @form.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activities/1
  # DELETE /activities/1.json
  def destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private

    def set_form
      @form = Form.find(params[:id])
    end

    def form_params
      #params.require(:form).permit(:name, :last_name, :email, :address, :path_url)
    end
end

