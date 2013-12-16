require 'spec_helper'

module Mws::Apis

  describe Orders do

    let(:defaults) {
      {
        merchant: 'GSWCJ4UBA31UTJ',
        access: 'AYQAKIAJSCWMLYXAQ6K3',
        secret: 'Ubzq/NskSrW4m5ncq53kddzBej7O7IE5Yx9drGrX'
      }
    }

    let(:connection) {
      Mws.connect(defaults)
    }

    let(:orders) { connection.orders }

    context 'status' do

      it 'should return a status code' do
        ['GREEN', 'YELLOW', 'RED'].should include orders.status(:market => 'ATVPDKIKX0DER')
      end

    end

    context 'send_fullfillment_data' do

      it 'should require an *_order_id (either Amazon or Merchant)' do
        expect {
          orders.send_fulfillment_data(Hash.new, [{}])
        }.to raise_error Mws::Errors::ValidationError, 'An *_order_id is needed'
      end

      it 'should require a valid *_order_id (either Amazon or Merchant)' do
        expect {
          orders.send_fulfillment_data({}, [{:amazon_order_id => ''}])
        }.to raise_error Mws::Errors::ValidationError, 'An *_order_id is needed'
      end

      it 'should require a valid *_order_id (either Amazon or Merchant)' do
        expect {
          orders.send_fulfillment_data({}, [{:merchant_order_id => ''}])
        }.to raise_error Mws::Errors::ValidationError, 'An *_order_id is needed'
      end

      it 'should require an carrier_code' do
        expect {
          orders.send_fulfillment_data({}, [{:amazon_order_id => '123'}])
        }.to raise_error Mws::Errors::ValidationError, 'A carrier_code is needed'
      end

      it 'should require an carrier_code' do
        expect {
          orders.send_fulfillment_data({}, [{:amazon_order_id => '12', :carrier_code => ''}])
        }.to raise_error Mws::Errors::ValidationError, 'A carrier_code is needed'
      end

      it 'should require a shipping_method' do
        expect {
          orders.send_fulfillment_data({}, [{:amazon_order_id => '123', :carrier_code => '12'}])
        }.to raise_error Mws::Errors::ValidationError, 'A shipping_method is needed'
      end

      it 'should require a shipping_method' do
        expect {
          orders.send_fulfillment_data({}, [{:amazon_order_id => '123', :carrier_code => '12', :shipping_method => ''}])
        }.to raise_error Mws::Errors::ValidationError, 'A shipping_method is needed'
      end

      it 'should require order_items as a array' do
        expect {
          orders.send_fulfillment_data({}, [{:amazon_order_id => '111', :order_items => '', :carrier_code => '12', :shipping_method => '123', :shipping_tracking_number => '12'}])
        }.to raise_error Mws::Errors::ValidationError, 'order_items must be a array.'
      end

    end

    context 'send_acknowledgement' do

      it 'should require an array of orders' do
        expect {
          orders.send_acknowledgement({}, {amazon_order_id: '111', merchant_order_id: 'XYZ', status_code: 'success'})
        }.to raise_error Mws::Errors::ValidationError, 'orders must be an array'
      end

      it 'should require an amazon_order_id' do
        expect {
          orders.send_acknowledgement({}, [{merchant_order_id: 'XYZ', status_code: 'success'}])
        }.to raise_error Mws::Errors::ValidationError, 'amazon_order_id entries are required'
      end

      it 'should require a merchant_order_id' do
        expect {
          orders.send_acknowledgement({}, [{amazon_order_id: '111', status_code: 'success'}])
        }.to raise_error Mws::Errors::ValidationError, 'merchant_order_id entries are required'
      end

      it 'should require a status_code' do
        expect {
          orders.send_acknowledgement({}, [{amazon_order_id: '111', merchant_order_id: 'XYZ'}])
        }.to raise_error Mws::Errors::ValidationError, 'status_code must be success or failure'
      end

      it 'should require a valid status_code' do
        expect {
          orders.send_acknowledgement({}, [{amazon_order_id: '111', merchant_order_id: 'XYZ', status_code: 'great'}])
        }.to raise_error Mws::Errors::ValidationError, 'status_code must be success or failure'
      end

    end
  end

end
