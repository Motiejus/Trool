class PosController < ApplicationController
  # GET /pos
  # GET /pos.xml
  def index
    @pos = Po.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pos }
    end
  end

  # GET /pos/1
  # GET /pos/1.xml
  def show
    @po = Po.find(params[:id])
    show = request.GET.fetch('show', nil)
    case show
    when 'translated'
      @messages = @po.messages.where("msgstr != ''").where("fuzzy == ?", false)
    when 'untranslated'
      @messages = @po.messages.where("msgstr == '' OR fuzzy == ? ", true)
    else
      @messages = @po.messages
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @po }
    end
  end

  # GET /pos/new
  # GET /pos/new.xml
  def new
    @po = Po.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @po }
    end
  end

  # GET /pos/1/edit
  def edit
    @po = Po.find(params[:id])
  end

  # POST /pos
  # POST /pos.xml
  def create
    params[:po][:pot] = Pot.find(params[:po][:pot])

    # Create po file
    @po = Po.new(params[:po])
    @po.populate_messages

    respond_to do |format|
      if @po.save
        format.html { redirect_to(@po, :notice => 'Po was successfully created.') }
        format.xml  { render :xml => @po, :status => :created, :location => @po }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @po.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pos/1
  # PUT /pos/1.xml
  def update
    params[:po][:pot] = Pot.find(params[:po][:pot])
    @po = Po.find(params[:id])

    respond_to do |format|
      if @po.update_attributes(params[:po])
        format.html { redirect_to(@po, :notice => 'Po was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @po.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pos/1
  # DELETE /pos/1.xml
  def destroy
    @po = Po.find(params[:id])
    @po.destroy

    respond_to do |format|
      format.html { redirect_to(pos_url) }
      format.xml  { head :ok }
    end
  end

  # GET /pos/1/download
  def download
    @po = Po.find(params[:id])
    render :text => @po.output, :content_type => 'text/plain'
  end
end
