ActiveAdmin.register Advisor do
  permit_params :name, :phone, :email, :website, :address, :city, :bio, :certifications, :specializations, :experience_years, :education, :availability, :avatar, :company_name, :licenses, :client_types, :pricing

  form do |f|
    f.semantic_errors # shows errors on :base
    f.inputs do
      f.input :name
      f.input :phone
      f.input :email
      f.input :website
      f.input :company_name
      f.input :address
      f.input :city
      f.input :certifications
      f.input :licenses
      f.input :specializations
      f.input :client_types
      f.input :experience_years
      f.input :education
      f.input :availability
      f.input :pricing
      f.input :bio, as: :text
      f.input :avatar, 
        as: :file, 
        hint: 
          (
            f.advisor.avatar.attached? && f.advisor.avatar.attachment.blob.present? && f.advisor.avatar.attachment.blob.persisted? ? 
              image_tag(f.advisor.avatar, height: '90') : 
                content_tag(:span, "Upload JPEG/JPG/PNG image")
          ), 
        accept: "image/png, image/jpg, image/jpeg"
      f.actions
    end
  end

  show do
    attributes_table do
      row :name
      row :phone
      row :email
      row :website
      row :company_name
      row :address
      row :city
      row :certifications
      row :licenses
      row :specializations
      row :client_types
      row :experience_years
      row :education
      row :availability
      row :pricing
      row :bio
      row :avatar do |av|
        image_tag url_for(av.avatar.variant(:thumb)) if av.avatar.attached?
      end
      active_admin_comments
    end
  end

  index do
    id_column
    column :name
    column :avatar do |av|
      image_tag url_for(av.avatar.variant(:thumb)), height: 45 if av.avatar.attached?
    end
    column :email
    column :phone
    column :city
    column :pricing
    actions
  end
end
