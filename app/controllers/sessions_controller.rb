class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # user  : find_byの該当があればモデルオブジェクト、なければnil
      # user.authenticate(xxx) :
      #             パスワード一致ならモデルオブジェクト、なければnil
      # ユーザーログイン後にユーザー情報のページにリダイレクトする
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

  end

end
