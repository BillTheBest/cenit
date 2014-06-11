module Hub
	class Customer
	  include Mongoid::Document
	  #include Mongoid::Attributes::Dynamic
	  include Mongoid::Timestamps

	  field :_id, type: String
    field :email, type: String
    field :firstname, type: String
    field :lastname, type: String

    belongs_to :shipping_address, class_name: 'Hub::Address'
    belongs_to :billing_address, class_name: 'Hub::Address'

    accepts_nested_attributes_for :shipping_address 
    accepts_nested_attributes_for :billing_address   

    validates_presence_of :id, :firstname, :lastname

	end
end