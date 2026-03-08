# frozen_string_literal: true

module ProductsHelper
  PRODUCT_IMAGES = {
    'A guided Lowland Walk' => { file: 'lowland_walk.png', position: 'object-cover' },
    'Conference Talk' => { file: 'conference_talk.png', position: 'object-cover object-center' }
  }.freeze

  def product_image_tag(product)
    image_config = PRODUCT_IMAGES[product.title]

    if product.external_url&.include?('rover.com')
      image_tag('jess_and_luna.png', alt: "#{product.title} - Jess and Luna", class: 'w-full h-48 object-cover')
    elsif image_config
      image_tag(image_config[:file], alt: product.title, class: "w-full h-48 #{image_config[:position]}")
    else
      content_tag(:div, class: 'w-full h-48 bg-sullips-chip flex items-center justify-center') do
        content_tag(:span, 'Image placeholder', class: 'text-sullips-muted text-sm')
      end
    end
  end
end
