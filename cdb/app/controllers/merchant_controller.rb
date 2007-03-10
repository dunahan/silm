class MerchantController < ApplicationController
  before_filter(:only => %w{index}) {|c| c.authenticate(Account::CAN_SEE_MERCHANTS) }
  before_filter(:only => %w{kill_merc kill_inv add}) {|c| c.authenticate(Account::CAN_EDIT_MERCHANTS) }

  # List all merchants and their inventory
  def index
    @merchants = Merchant.find(:all)    
  end

  def kill_merc
    m = params[:id]
    MerchantInventory.delete_all("merchant = ?", m)
    Merchant.delete(m)
  end

  def kill_inv
    m = MerchantInventory::find(params[:id]).merchant
    MerchantInventory.delete(params[:id])
    redirect_to :action => 'edit', :controller => 'merchant', :id => m
  end

  def add
    m = Merchant.new({
      'text_buy' => 'So waehlt aus meinen exzellenten Waren!',
      'text_sell' => 'Ich bin sicher, dass wir ins Geschaefte kommen.',
      'text_nothingtobuy' => 'Nichts das Ihr mir anbietet findet Platz in meinem Geschaefte.',
      'text_nothingtosell' => 'Derzeit habe ich keine Waren, die fuer Eure genannten Zwecke sinnvoll sind.',
      'text_pcnomoney' => 'Mit Verlaub, mitnichten. Wovon wollt Ihr mich nur bezahlen?',
      'text_mercnomoney' => 'Derzeit kann ich Euch leider nicht entlohnen. Versucht es zu spaeterer Zeit.',
    })
    m.tag = params['tag']
    m.save
    redirect_to :action => 'edit', :id => m.id
  end


  def edit
    if params[:id] == 0 || params[:id] == ""
      @m = Merchant.new
    else
      begin
        @m = Merchant.find(params[:id])
      rescue
        @m = nil
        return
      end
    end

    @mm = @m.merchant_inventory

if amask(Account::CAN_EDIT_MERCHANTS)
    defaults = {
      'resref' => "",
      'min' => 0,
      'cur' => 1,
      'max' => 25,
      'buy_markup' => 1.0,
      'sell_markdown' => 1.0,
      'comment' => 'add by %s' % [get_user.account],
    }

    @new = MerchantInventory.new(defaults)
    @new.merchant = @m.id

    params['mm'].each do |k, m|
      mi = @mm[k.to_i]
      if !mi || mi.merchant.to_i != @m['id'].to_i
        flash[:notice] = "Merchant ID invalid. stop frelling around with it (#{mi.merchant.to_i} vs #{@m['id'].to_i}"
      else
        mi.update_attributes(m)
        if !mi.save
          flash[:notice] = "Cannot save!"
          flash[:errors] = mi.errors
          return
        end
      end
    end if params['mm']

    if params['new'] && params['new']['resref'] != ""
      n =  MerchantInventory::new(params['new'])
      n.merchant = @m.id
      if !n.save
        flash[:notice] = "Cannot save!"
        flash[:errors] = mi.errors
        return
      end
      flash[:notice] = "Saved!"
    end
    
    
    @m.update_attributes(params['m'])
    @m.save
  end
end

end
