require 'json'
require 'sinatra/param'


class ApiSisms
  helpers Sinatra::Param

  before do
    content_type :json
  end

  get '/api/features' do
    cross_origin
    param :mag_type,  Array, default: []
    param :page, Integer, default: 1
    param :per_page, Integer, default: 20
    # Params
    mag_type = params[:mag_type]
    page = params[:page].to_i
    per_page = params[:per_page].to_i

    result = []
    count = Feature.count

    if mag_type.length == 0
      # All

      items = Feature.limit(per_page).offset( (page- 1) * per_page).all
      items.each { |feature|
        # feat = feature.to_hash

        result.append({
            id: feature.id,
            type: "feature",
            attributes: {
              external_id: feature.external_id,
              magnitude: feature.mag,
              place: feature.place,
              time: feature.time,
              tsunami: feature.tsunami,
              mag_type: feature.mag_type,
              title: feature.title,
              coordinates: {
                longitude: feature.longitude,
                latitude: feature.latitude,
              }
            },
            links: {
              external_url: feature.url,
            }
        })
      }
      {data: result, pagination: {curret_page: page, total: count, per_page: per_page} }.to_json

    else
      items = Feature.where(mag_type: mag_type).limit(per_page).offset( (page- 1) * per_page)
      items.each { |feature|

        result.append({
          id: feature.id,
          type: "feature",
          attributes: {
            external_id: feature.external_id,
            magnitude: feature.mag,
            place: feature.place,
            time: feature.time,
            tsunami: feature.tsunami,
            mag_type: feature.mag_type,
            title: feature.title,
            coordinates: {
              longitude: feature.longitude,
              latitude: feature.latitude,
            }
          },
          links: {
            external_url: feature.url,
          }
        })
      }
      {data: result, pagination: {curret_page: page, total: count, per_page: per_page} }.to_json
    end
  end

  def getBody (req)
    ## Rewind the body in case it has already been read
    req.body.rewind
    ## parse the body
    return JSON.parse(req.body.read)
  end

  get '/api/features/:id/comments' do
    cross_origin
    param :id,  Integer, default: nil

    id = params[:id]
    result = []
    items = FeatureComment.where(feature_id: id).all
    items.each { |item|
      result.append({comment: item.comment, created_at: item.created_at})
    }
    {data: result}.to_json
  end

  post '/api/features/:id/comments' do
    cross_origin
    param :id,  Integer, default: nil

    id = params[:id]
    # Pass the request into the custom getBody function
    body = getBody(request)
    begin
      #print body["body"]
      FeatureComment.create(feature_id: id, comment: body["body"])
      # print item
      {message: "Comentario enviado correctamente"}.to_json
    rescue Exception=>e
      print e.message
      {error: 'Ocurrio un error, por favor intente más tarde'}.to_json
    end
  end
end
