# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

Product.find_or_create_by(title: 'A guided Lowland Walk') do |product|
  product.description = 'Jess is a qualified Lowland leader so she can lead you and a group of friends on beautiful walks through the Scottish Lowlands. Whether you\'re looking for a gentle stroll or a more challenging hike, Jess can tailor the experience to your group\'s needs and interests.'
  product.amount_type = Product::AMOUNT_TYPE_VARIABLE
  product.external_url = nil
  product.requires_booking = true
end

Product.find_or_create_by(title: 'Conference Talk') do |product|
  product.description = 'Jess can talk about all sorts of things, from Rails internals to leading book clubs! Best to contact her to discuss what you\'re looking for. Whether it\'s a technical deep-dive, a workshop, or an inspiring keynote, she\'ll work with you to create the perfect talk for your audience.'
  product.amount_type = Product::AMOUNT_TYPE_VARIABLE
  product.external_url = nil
  product.requires_booking = true
end

Product.find_or_create_by(title: 'Dog Sitting') do |product|
  product.description = 'Jess loves dogs and would be happy to watch yours! Whether you need someone to look after your furry friend for a few hours or a few days, Jess provides reliable and caring dog sitting services.'
  product.amount_type = Product::AMOUNT_TYPE_VARIABLE
  product.external_url = 'https://www.rover.com/sit/jessis88240'
  product.requires_booking = false
end

Product.where(title: 'Dog Sitting').update_all(requires_booking: false)
