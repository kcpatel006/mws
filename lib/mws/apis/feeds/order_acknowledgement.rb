module Mws::Apis::Feeds

  class OrderAcknowledgement

    attr_reader :amazon_order_id, :merchant_order_id, :status_code

    def initialize(amazon_order_id, merchant_order_id, status_code)
      @amazon_order_id    = amazon_order_id
      @merchant_order_id  = merchant_order_id
      @status_code        = status_code
    end

    def to_xml(name='Orders/Order', parent=nil)
      Mws::Serializer.tree name, parent do |xml|
        xml.MessageType 'OrderAcknowledgement'
        xml.Message {
          xml.MessageID '1'
          xml.OrderAcknowledgement {
            xml.AmazonOrderID     @amazon_order_id
            xml.MerchantOrderID   @merchant_order_id
            xml.StatusCode        @status_code
          }
#            order_items.each do | item |
#              xml.Item {
#                xml.AmazonOrderItemCode item[:order_item_id]
#                xml.MerchantOrderItemID item[:merchant_order_id]
#              }
#            end
        }
      end
    end

  end

end
