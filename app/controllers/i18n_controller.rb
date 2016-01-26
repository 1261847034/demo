class I18nController < ApplicationController

  before_action :available_locales, only: [:index, :update]

  def update
    if params[:locale].in?(@locales)
      I18n.locale = params[:locale]
    else
      flash[:error] = '参数不正确'
    end
    redirect_to i18n_index_path
  end

  def export
    to_backend if params[:file].present?
    render nothing: true
  end

  private

  def available_locales
    @locales = Rails.application.config.i18n.available_locales.map(&:to_s)
  end

  def to_backend
    dict.each do |locale, value|
      I18n.backend.store_translations(locale, value, escape: false)
    end
  end

  def dict
    dict = {}
    oo = Roo::Spreadsheet.open(params[:file].path)
    oo.each_with_pagename do |name, sheet|
      1.upto(sheet.last_row) do |line|
        locale, key, _, value = sheet.row(line)
        dict[locale] ||= {}
        dict[locale][key] = value
      end
    end
    dict
  end

end