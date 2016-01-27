class SimditorsController < ApplicationController

  def new
    @article = SimditorArticle.new
  end

  def create
    @article = SimditorArticle.new(article_params)
    if @article.save
      redirect_to new_simditor_path, notice: '保存成功'
    else
      flash[:error] = @article.errors.full_messages.join(',')
      render :new
    end
  end

  def upload
    @photo = SimditorPhoto.new(image: params[:upload_file])
    if @photo.save
      render json: {success: true, msg: '图片上传成功', file_path: @photo.image.url }
    else
      render json: {success: false, msg: "图片上传失败: #{@photo.errors.full_messages.join(',')}"}
    end
  end

  def article_params
    params.require(:simditor_article).permit(:content)
  end

end