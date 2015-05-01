require 'webrick'
require 'launchy'
require 'pry'
class GoogleAuthClient

  RESPONSE_BODY = <<-HTML
    <html>
      <head>
        <script>
          function closeWindow() {
            window.open('', '_self', '');
            window.close();
          }
          setTimeout(closeWindow, 10);
        </script>
      </head>
      <body>You may close this window.</body>
    </html>
  HTML

  ##
  # Configure the flow
  #
  # @param [Hash] options The configuration parameters for the client.
  # @option options [Fixnum] :port
  #   Port to run the embedded server on. Defaults to 9292
  # @option options [String] :client_id
  #   A unique identifier issued to the client to identify itself to the
  #   authorization server.
  # @option options [String] :client_secret
  #   A shared symmetric secret issued by the authorization server,
  #   which is used to authenticate the client.
  # @option options [String] :scope
  #   The scope of the access request, expressed either as an Array
  #   or as a space-delimited String.
  #
  # @see Signet::OAuth2::Client
  def initialize(options)
    @host = options[:host] || 'localhost'
    @port = options[:port]
    @redirect_uri = @port ? "http://#{@host}:#{@port}#{options[:redirect_url]}" : "#{@host}#{options[:redirect_url]}"  
    @authorization = Signet::OAuth2::Client.new({
      :authorization_uri => 'https://accounts.google.com/o/oauth2/auth',
      :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
      :redirect_uri => "#{@redirect_uri}"}.update(options)
    )
  end

  ##
  # Request authorization. Opens a browser and waits for response.
  #
  # @param [Google::APIClient::Storage] storage
  #  Optional object that responds to :write_credentials, used to serialize
  #  the OAuth 2 credentials after completing the flow.
  #
  # @return [Signet::OAuth2::Client]
  #  Authorization instance, nil if user cancelled.
  def authorize(storage=nil)
    auth = @authorization    
    server = WEBrick::HTTPServer.new(
      :Port => @port,
      :BindAddress => @host,
      :Logger => WEBrick::Log.new(STDOUT, 0),
      :AccessLog => []
    )
    begin
      server.mount_proc '/auth/google/callback' do |req, res|
        auth.code = req.query['code']
        if auth.code
          auth.fetch_access_token!
        end
        res.status = WEBrick::HTTPStatus::RC_ACCEPTED
        res.body = RESPONSE_BODY
        @authorization = auth
        server.stop
      end

      Launchy.open(auth.authorization_uri.to_s)
      server.start
    ensure
      server.shutdown
    end
    if @authorization.access_token
      return @authorization
    else
      return nil
    end
  end
end