require './lib/methods.rb'

url = "https://14qjgk812kgk.statuspage.io/api/v2/incidents/unresolved.json"


# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1m', :first_in => 0 do |job|

# Get and parse upcoming incidents JSON
response = HTTParty.get(url)
response = response.parsed_response

incident = Hash.new

unless response['incidents'].empty?

	response['incidents'][0].each do |key, value|
		incident['icon'] = 'fa fa-exclamation-circle'
		incident[key] = value
	end

	incident['incident_updates'][0].each do |key, value|
		incident[key] = value
	end
	incident.delete('incident_updates')
	incident['created_at'] = fixTime(incident['created_at'])

else

	timeStamp = Time.now
	time = fixTime(timeStamp.to_s)

	incident['icon'] = 'fa fa-check-circle'
	incident['name'] = 'No Incidents!'
	incident['created_at'] = "#{time}"
	incident['impact'] = 'N/A'
	incident['body'] = "Zoom has no unresolved incidents"

end

  send_event('incidents', {incident: incident} )
end