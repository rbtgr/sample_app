class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # user  : find_byの該当があればモデルオブジェクト、なければnil
      # user.authenticate(xxx) :
      #             パスワード一致ならモデルオブジェクト、なければnil
      log_in(user) # session helper
       # session の :user_id に、userのid値を保存

      redirect_to user
     # redirect_to user_url(user) と同じ

    else
    # エラーメッセージ
      #表示したテンプレートをrenderメソッドで強制的に再レンダリングしても
      #リクエストと見なされないため、リクエストのメッセージが消えない
      #この場合、flash.now とすれば、現在のActionのみ有効になる
      flash.now[:danger] = 'Invalid email/password combination'

      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

end
