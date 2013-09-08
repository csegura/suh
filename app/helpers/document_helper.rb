module DocumentHelper

  def document_icon document, options = {}
    preview = options.delete :preview
    if preview && document.is_image?
      document_icon_preview document, options
    else
      document_icon_base document, options
    end
  end

  # show file icon, for images show preview
  # :format => :thumb, medium
  def document_icon_base document, options = {}
    format = :thumb
    format = options.delete(:format) if options.has_key?(:format)
    if document.is_image?
      asset = document.asset
      image_tag asset.url(format), options
    else
      icon_tag document.asset_file_name, options
    end
  end

  def document_icon_preview document, options
    link_to document_icon_base(document,options),
            document.asset.url,
            :class => :preview,
            :title => document.asset_file_name,
            :rel => :docs
  end

  def link_download_document document
    link_to '', download_document_path(document), :class => :download
  end

private

  # show icon accord to file extension
  # used by document_icon
  def icon_tag(file_name, options = {})
    ext = "#{File.extname(file_name).gsub('.', '')}"
    k = %w(ac3 aiff avi bmp cab dat doc docx dvd dwg fon gif html ico ifo jif jpg log m4a mp3 mpeg msp pdf png ppt pptx psd rtf tiff ttf txt wav wmv wri xls xlsx xml xsl zip)
    options.merge!({:size => "24x24", :alt => ext})
    if k.include?(ext)
      image_tag "doc_icons/#{ext}.png", options
    else
      Rails.logger.info url
      image_tag "doc_icons/default.png", options
    end
  end


end