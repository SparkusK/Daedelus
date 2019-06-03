  module DataManipulation
    class AdministrativeController < ApplicationController
      #before_action :authenticate_user!
      before_action :set_dates, only: :index
      before_action :authenticate_user!

      # GET /entities
      # GET /entities.json
      def index
        respond_to do |format|
          format.html
          format.js
        end
      end

      # GET /entities/new
      def new
      end

      # POST /entities
      # POST /entities.json
      def create
        instance = subclass_model.new(whitelist_params)
        respond_to do |format|
          if instance.save
            format.html { redirect_to instance, notice: "#{instance} was successfully created." }
            format.json { render :show, status: :created, location: entity }
          else
            format.html { render :new }
            format.json { render json: instance.errors, status: :unprocessable_entity }
          end
        end
      end

      # GET /entity/1
      # GET /entity/1.json
      def show
      end

      # PATCH/PUT /entities/1
      # PATCH/PUT /entities/1.json
      def update
        respond_to do |format|
          if params[:commit] == "Save"
            if instance.update(whitelist_params)
              notice_string = "#{entity_string} was successfully updated."
              format.html { redirect_to credit_note, notice: notice_string }
              format.json { render :show, status: :ok, location: credit_note }
              format.js
            else
              format.html { render :edit }
              format.json { render json: credit_note.errors, status: :unprocessable_entity }
              format.js { render 'edit' }
            end
          else
            format.js { render action: "cancel" }
          end
        end
      end

      # GET /entity/1/edit
      def edit
        respond_to do |format|
          format.html
          format.js
        end
      end

      # DELETE /entities/1
      # DELETE /entities/1.json
      def destroy
        instance.destroy
        respond_to do |format|
          entity_string = subclass_model.to_s.underscore.humanize
          notice_string = "#{entity_string} was successfully destroyed."
          url_controller_string = "#{instance.class.to_s.pluralize.underscore}"
          url = url_for(controller: url_controller_string,
            action: 'index')
          format.html { redirect_to url,
                        notice: notice_string }
          format.json { head :no_content }
        end
      end

      # GET /entity/1.js
      def cancel
        instance = subclass_model.find_by(id: params[:id])
        respond_to { |format| format.js }
      end


      private
        def set_dates
          @dates = Utility::DateRange.new( start_date: params[:start_date],
            end_date: params[:end_date] )
        end

        def whitelist_params
          raise NotImplementedError
        end

        def subclass_model
          controller_name.classify.constantize
        end

        def instance
          raise NotImplementedError
        end

        def entity_string
          subclass_model.underscore.humanize
        end
  end
end
