class SessionsController < ApplicationController
  def new
  end

  def create
    render 'new'
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # user  : find_byの該当があればモデルオブジェクト、なければnil
      # user.authenticate(xxx) :
      #             パスワード一致ならモデルオブジェクト、なければnil
      # ユーザーログイン後にユーザー情報のページにリダイレクトする
    else
    # エラーメッセージ
      #表示したテンプレートをrenderメソッドで強制的に再レンダリングしても
      #リクエストと見なされないため、リクエストのメッセージが消えません
      flash[:danger] = 'Invalid email/password combination'

      render 'new'
    end
  end

  def destroy

  end

end
