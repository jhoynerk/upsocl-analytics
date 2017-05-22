require 'rails_helper'

describe 'TypesHelpers' do

  it 'When value is "pagina" or return should by UPSOCL' do
    expect(TrafficStadistics::TypesHelpers.type_by('pagina')).to eq(TrafficTypeStadistics::UPSOCL)
  end

  it 'When value is "direct" or return should by UPSOCL' do
    expect(TrafficStadistics::TypesHelpers.type_by('pagina')).to eq(TrafficTypeStadistics::UPSOCL)
  end

  it 'When value is "facebook" or return should by FACEBOOK' do
    expect(TrafficStadistics::TypesHelpers.type_by('facebook')).to eq(TrafficTypeStadistics::FACEBOOK)
  end

  it 'When value is "referall" or return should by FACEBOOK' do
    expect(TrafficStadistics::TypesHelpers.type_by('facebook')).to eq(TrafficTypeStadistics::FACEBOOK)
  end

  it 'When value is "any string" or return should by OTHERS' do
    expect(TrafficStadistics::TypesHelpers.type_by('house')).to eq(TrafficTypeStadistics::OTHERS)
    expect(TrafficStadistics::TypesHelpers.type_by('method')).to eq(TrafficTypeStadistics::OTHERS)
    expect(TrafficStadistics::TypesHelpers.type_by(nil)).to eq(TrafficTypeStadistics::OTHERS)
    expect(TrafficStadistics::TypesHelpers.type_by('')).to eq(TrafficTypeStadistics::OTHERS)
    expect(TrafficStadistics::TypesHelpers.type_by(124)).to eq(TrafficTypeStadistics::OTHERS)
  end
end
