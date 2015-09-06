class CatchJsonParseErrors
  def initialize(app)
    @app = app
  end

  def call(env)
    begin
      @app.call(env)
    rescue ActionDispatch::ParamsParser::ParseError => error
      if env['HTTP_ACCEPT'] =~ /json/
        return [
          415, { "Content-Type" => "application/json" },
          [{
            errors: [{
              status: '415',
              title: "Invalid JSON submitted",
              detail: error.message
            }] }.to_json]
        ]
      else
        raise error
      end
    end
  end
end
