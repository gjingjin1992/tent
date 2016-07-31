namespace :db do
  desc 'Generate and load fake data'
  task load_fake_data: :environment do

    # Data

    coordinates = [
      {latitude: 52.127167290706100, longitude: -2.325074601456600},
      {latitude: 51.550918461192200, longitude: -0.143448737952617},
      {latitude: 55.860466794624700, longitude: -4.146030313141820},
      {latitude: 54.527010097785300, longitude: -1.299289511293200},
      {latitude: 50.356058567521800, longitude: -3.589855310185210},
      {latitude: 51.152231960726100, longitude: 0.193273640659429},
      {latitude: 51.372514704038900, longitude: -1.193603981505390},
      {latitude: 54.988870000000000, longitude: -7.349346000000000},
      {latitude: 51.380628797056600, longitude: -0.082749467298793},
      {latitude: 52.441537764350900, longitude: -1.531694845409040},
      {latitude: 55.064837652371000, longitude: -3.592375049779280},
      {latitude: 51.147237820000000, longitude: -2.724749997000000},
      {latitude: 53.348049546951000, longitude: -4.297384464658650},
      {latitude: 51.384557788012000, longitude: -0.354161843834752},
      {latitude: 51.706500026581700, longitude: -3.413069710866810},
      {latitude: 54.597836809439900, longitude: -1.048919758224890},
      {latitude: 51.541510743439800, longitude: 0.644506834663725},
      {latitude: 51.368656677166900, longitude: -0.366196230813146},
      {latitude: 51.493210066139100, longitude: -0.197985965422278},
      {latitude: 54.974764481569200, longitude: -1.572226393894500},
      {latitude: 52.271076674915700, longitude: -1.175601974120970},
      {latitude: 51.508550932657700, longitude: -0.144335703135741},
      {latitude: 54.603416000000000, longitude: -5.864048000000000},
      {latitude: 51.622653364123300, longitude: -0.468975700194837},
      {latitude: 54.944021720556300, longitude: -1.803042848077780},
      {latitude: 53.219461025246100, longitude: -0.605390248898024},
      {latitude: 53.517926187101500, longitude: -2.510908994548150},
      {latitude: 52.527015263382200, longitude: -2.063293437305770},
      {latitude: 55.940335319829500, longitude: -3.282910803033040},
      {latitude: 50.485957746184500, longitude: -4.470584340929690},
      {latitude: 55.651912973861500, longitude: -3.185116101090120},
      {latitude: 50.705956391649000, longitude: -4.370013645207480},
      {latitude: 51.218646230302100, longitude: -0.495231056059436},
      {latitude: 51.291615756402200, longitude: 0.309420705140587},
      {latitude: 51.889408021479200, longitude: -2.129767210947140},
      {latitude: 53.738888480604300, longitude: -0.187771509931770},
      {latitude: 52.480158424698400, longitude: -2.122196143863550},
      {latitude: 57.406309889983600, longitude: -5.479657787013030},
      {latitude: 50.938595056169900, longitude: 0.663822166256583},
      {latitude: 53.759502748044900, longitude: -0.201007423057072},
      {latitude: 51.541349495837200, longitude: -0.647747847745942},
      {latitude: 51.528972815393500, longitude: -0.169513672790352},
      {latitude: 53.592625960000000, longitude: -2.310206533000000},
      {latitude: 52.247693364781600, longitude: -0.882673130393373},
      {latitude: 52.607711032091700, longitude: -1.074948134224100},
      {latitude: 54.918391196845400, longitude: -1.419920944358360},
      {latitude: 52.334294163084700, longitude: -0.069426217912128},
      {latitude: 50.731095730000000, longitude: -1.947182410000000},
      {latitude: 51.391026203137800, longitude: 0.465271697480042},
      {latitude: 56.414235556281000, longitude: -3.471558763508940},
      {latitude: 54.370320000000000, longitude: -6.681603000000000},
      {latitude: 51.524501611318500, longitude: -0.112088280168721},
      {latitude: 53.507329920228500, longitude: -2.433266172767770},
      {latitude: 51.011572965985100, longitude: 0.282961981521612},
      {latitude: 51.926957921146200, longitude: 1.259078530549330},
      {latitude: 51.900081866812400, longitude: -0.470682228788860},
      {latitude: 51.902128335240500, longitude: -3.763597486285510},
      {latitude: 53.475810876400000, longitude: -2.199578341200000},
      {latitude: 53.500692900000000, longitude: -2.244906099999980},
      {latitude: 51.512661602017400, longitude: -0.133071533401603},
      {latitude: 54.119798000000000, longitude: -6.269503000000000},
      {latitude: 53.222470591574700, longitude: -1.466714372090320},
      {latitude: 54.943022600363300, longitude: -1.781037421947170},
      {latitude: 51.774405970000000, longitude: -0.301142680000000},
      {latitude: 51.369640923822400, longitude: 1.303818121492330},
      {latitude: 52.414415444531900, longitude: -1.572281205299950},
      {latitude: 53.580715231241600, longitude: -1.772770051112340},
      {latitude: 54.549081000000000, longitude: -5.908345000000000},
      {latitude: 55.628758582351900, longitude: -4.502381488774240},
      {latitude: 52.699013744964400, longitude: -2.732921626182950},
      {latitude: 52.536421317578500, longitude: -1.398912425302880},
      {latitude: 53.541492844810400, longitude: -2.099826343137200},
      {latitude: 52.634497730603000, longitude: 1.366194140072160},
      {latitude: 53.881986173306300, longitude: -2.769966027165290},
      {latitude: 54.885391965349800, longitude: -1.597583891879240},
      {latitude: 56.744588442405600, longitude: -2.601813382519200},
      {latitude: 53.766456124944000, longitude: -2.726160579554570},
      {latitude: 52.552222954777000, longitude: -1.157941020267630},
      {latitude: 53.798560500000000, longitude: -2.270187470000000},
      {latitude: 56.466246537963900, longitude: -4.318167168834230},
      {latitude: 51.461129413198900, longitude: -2.552895366998330},
      {latitude: 51.115163648587000, longitude: -1.740984157938070},
      {latitude: 52.655713936230800, longitude: -1.403561170234160},
      {latitude: 53.378502718587300, longitude: -2.857615832116680},
      {latitude: 51.762272917326500, longitude: 0.131650257998526},
      {latitude: 53.637178901176300, longitude: -2.991459622907750},
      {latitude: 51.442425952429300, longitude: -0.022084887731989},
      {latitude: 52.359375622216200, longitude: -1.279364169275940},
      {latitude: 52.790041783761800, longitude: -0.134852815696765},
      {latitude: 53.472027709357400, longitude: -2.122125065856090},
      {latitude: 51.645250051180300, longitude: -2.652310551579710},
      {latitude: 51.903278147151200, longitude: 0.811954883363717},
      {latitude: 51.644100583013000, longitude: -1.865810719252170},
      {latitude: 53.255331852536500, longitude: -2.128970194061800},
      {latitude: 50.737160940000000, longitude: -1.937383560000000},
      {latitude: 52.933737149814700, longitude: -4.134466172136380},
      {latitude: 51.521290165202200, longitude: -0.173353304080747},
      {latitude: 54.963677811602300, longitude: -3.991072202879460},
      {latitude: 51.277433158447300, longitude: -1.107915293636800},
      {latitude: 55.848577875108000, longitude: -4.364560354430410},
      {latitude: 53.687727793799000, longitude: -1.634174295014920},
      {latitude: 52.489632450000000, longitude: -1.978955106000000},
      {latitude: 51.747824313580400, longitude: -2.325818702919640},
      {latitude: 54.204021000000000, longitude: -6.510555000000000},
      {latitude: 52.633414341845800, longitude: -2.222875784931640},
      {latitude: 50.282233930666600, longitude: -3.782177643163910},
      {latitude: 55.856604194409000, longitude: -4.342469286181720},
      {latitude: 53.539350325939900, longitude: -2.146552243147110},
      {latitude: 50.868097239915600, longitude: 0.548266650349967},
      {latitude: 50.790944746316300, longitude: 0.043011407195521},
      {latitude: 50.633763539428200, longitude: -3.397858141604710},
      {latitude: 53.094791434579800, longitude: -3.000103742386170},
      {latitude: 55.517123185493700, longitude: -4.596868034130870},
      {latitude: 53.125826714868300, longitude: -2.375783571479830},
      {latitude: 50.908745193942400, longitude: -1.389969318596410},
      {latitude: 53.742653072666200, longitude: -1.600007972847050},
      {latitude: 52.966646463942200, longitude: -1.204079611164460},
      {latitude: 51.608439329091900, longitude: -3.076025384379320},
      {latitude: 52.498204360000000, longitude: -1.871715332000000},
      {latitude: 51.499692894625800, longitude: -0.252608848686753},
      {latitude: 52.374236991959000, longitude: -2.711138194725740},
      {latitude: 53.518530039985800, longitude: -2.156177797283540},
      {latitude: 51.699827731888100, longitude: -0.418474303101311},
      {latitude: 51.588167194417600, longitude: 0.217037478361216},
      {latitude: 52.582113486835000, longitude: -1.119409063240480},
      {latitude: 51.328446250000000, longitude: -2.284170195000000},
      {latitude: 50.793412067854900, longitude: -0.610730991934544},
      {latitude: 53.418076409223200, longitude: -2.987302123303650},
      {latitude: 52.774788983299200, longitude: -1.201178698721700},
      {latitude: 54.971155230783900, longitude: -2.096101308726820},
      {latitude: 51.604058737239900, longitude: 0.691656578957799},
      {latitude: 53.525728590398700, longitude: -1.417857393732030},
      {latitude: 54.549284436923600, longitude: -1.199980395121760},
      {latitude: 54.998350557473800, longitude: -1.434900562529410},
      {latitude: 51.479210987860400, longitude: -3.175179078196360},
      {latitude: 51.481161043338200, longitude: -0.610400661903773},
      {latitude: 53.197725970162900, longitude: -2.884479716775070},
      {latitude: 51.329980912196100, longitude: -0.828944107368479},
      {latitude: 51.084447966924900, longitude: -1.139814332783870},
      {latitude: 51.557522172100900, longitude: -1.796280219204810},
      {latitude: 53.985487120000000, longitude: -1.982197937000000},
      {latitude: 51.826657562003200, longitude: -1.298776307726180},
      {latitude: 50.861320870000000, longitude: -0.406798018000000},
      {latitude: 52.585479499968800, longitude: 1.191667710205740},
      {latitude: 55.955988796487800, longitude: -3.203601661747240},
      {latitude: 51.498461895609600, longitude: -3.228761776110040},
      {latitude: 53.500979206500000, longitude: -2.224510946600000},
      {latitude: 51.546371391813100, longitude: -0.126110476801623},
      {latitude: 51.479645084046100, longitude: 0.093010970241727},
      {latitude: 50.764973730000000, longitude: -1.995311406000000},
      {latitude: 55.917578237216900, longitude: -3.244924936264810},
      {latitude: 55.898689651921800, longitude: -3.575271847238950},
      {latitude: 53.076253060604600, longitude: -0.810546437740997},
      {latitude: 56.422557086473700, longitude: -3.401630409190690},
      {latitude: 51.458009810999100, longitude: -0.486466459717903},
      {latitude: 51.534535735857200, longitude: -0.184920382460076},
      {latitude: 51.496523855381900, longitude: -0.313035757884957},
      {latitude: 52.654006603800000, longitude: 0.959429367900000},
      {latitude: 50.834387958142200, longitude: -1.180316896432140},
      {latitude: 51.294256190796400, longitude: -0.226756278595290},
      {latitude: 51.738810460000000, longitude: -0.306388533000000},
      {latitude: 51.625318532100800, longitude: 0.316129405658448},
      {latitude: 51.522138671168700, longitude: -0.159178434096555},
      {latitude: 50.209083941947900, longitude: -5.486382569473810},
      {latitude: 52.233408512979900, longitude: -2.740820309496710},
      {latitude: 53.025799199940600, longitude: -1.289676106077730},
      {latitude: 51.956305287358400, longitude: -0.261952238742491},
      {latitude: 52.606840494299400, longitude: -1.090235649474230},
      {latitude: 53.749480265369200, longitude: -0.345167194762832},
      {latitude: 51.721040444557900, longitude: -1.224727207609540},
      {latitude: 51.181618674797700, longitude: -3.446904640270290},
      {latitude: 53.310077594021300, longitude: -0.951535830371191},
      {latitude: 53.396971037941700, longitude: -3.011914071064640},
      {latitude: 57.193548105328000, longitude: -3.827841839074260},
      {latitude: 53.592871729880100, longitude: -2.219574229110930},
      {latitude: 53.011012218437500, longitude: -2.128462760223700},
      {latitude: 53.562689861016000, longitude: -2.318924985824170},
      {latitude: 53.850566112219100, longitude: -0.439360670758495},
      {latitude: 50.815334380000000, longitude: -0.350828268000000},
      {latitude: 53.315525531394800, longitude: -3.403064138066510},
      {latitude: 50.541149864713300, longitude: -3.655657729049640},
      {latitude: 52.404156370000000, longitude: -1.895608776000000},
      {latitude: 52.592062446607000, longitude: -0.207641151109234},
      {latitude: 52.413428428608200, longitude: -1.512350537135430},
      {latitude: 54.610532169748400, longitude: -1.570122328558420},
      {latitude: 52.080247502672900, longitude: -1.367276872634010},
      {latitude: 51.614584082318000, longitude: -0.137732028958431},
      {latitude: 52.067202045997300, longitude: -1.345870685985000},
      {latitude: 51.315896670000000, longitude: -2.229597166000000},
      {latitude: 55.917262615307300, longitude: -3.167999984575480},
      {latitude: 51.509628565928000, longitude: -0.004577093611414},
      {latitude: 54.979504938235000, longitude: -1.668859670518180},
      {latitude: 50.735575583170000, longitude: -1.262503191587910},
      {latitude: 51.723452223684900, longitude: -3.249374732309950},
      {latitude: 53.066688447221700, longitude: -2.153177692474960},
      {latitude: 50.725251410000000, longitude: -1.949229034000000},
      {latitude: 53.649128152141300, longitude: -1.822689255679140},
      {latitude: 52.655373839271600, longitude: -1.072346027975680},
      {latitude: 52.805027213678400, longitude: -2.114770324070010},
      {latitude: 51.646652781329000, longitude: -0.220787698953414}
    ]

    countries = ['England', 'Nothern Ireland', 'Scotland', 'Wales']

    # Owners

    puts "Generating owners..."

    owners = (1..40).map do
      name = Faker::Name.name
      FactoryGirl.create(:owner,
        name:  name,
        email: Faker::Internet.email(name),
        password: 'supersecret',
        password_confirmation: 'supersecret',

        country:   'United Kingdom',
        county:    Faker::Lorem.word.capitalize,
        city:      Faker::Address.city,
        town:      Faker::Address.city,
        postcode:  Faker::Address.postcode,
        telephone: Faker::PhoneNumber.phone_number,

        address1:  Faker::Address.street_address,
      )
    end

    # Sites

    puts "Generating sites..."

    site_types = SiteType.all

    sites = coordinates.map do |coords|
      FactoryGirl.create(:site,

        owner: owners.sample,

        type:  site_types.sample,
        name:  Faker::Lorem.words(rand(2..4)).join(' '),
        email: Faker::Internet.email,

        country:   'United Kingdom',
        county:    Faker::Lorem.word.capitalize,
        city:      Faker::Address.city,
        town:      Faker::Address.city,
        postcode:  Faker::Address.postcode,
        telephone: Faker::PhoneNumber.phone_number,

        address1:  Faker::Address.street_address,
        address2:  Faker::Address.street_address,
        address3:  Faker::Address.street_address,

        latitude:  coords[:latitude],
        longitude: coords[:longitude],

        general_desc:  Faker::Lorem.sentence,
        detailed_desc: Faker::Lorem.paragraph,

        arrival_time:   '10:00:00',
        departure_time: '12:00:00'
      )
    end

    # Pitches

    puts "Generating pitches..."

    pitch_types = PitchType.all

    sites.each do |site|
      rand(8..15).times do
        FactoryGirl.create(:pitch,
          site: site,
          type: pitch_types.sample,
          name: Faker::Lorem.words(rand(2..4)).join(' '),
          max_persons: rand(2..10),
          length: rand(5..10),
          width:  rand(5..10)
        )
      end
    end

    # Rates

    puts "Generating rates..."

    rates = [
      {from: '2016-01-01', to: '2016-01-31'},
      {from: '2016-02-01', to: '2016-02-29'},
      {from: '2016-03-01', to: '2016-03-31'},
      {from: '2016-04-01', to: '2016-04-30'},
      {from: '2016-05-01', to: '2016-05-31'},
      {from: '2016-06-01', to: '2016-06-30'},
      {from: '2016-07-01', to: '2016-07-31'},
      {from: '2016-08-01', to: '2016-08-31'},
      {from: '2016-09-01', to: '2016-09-30'},
      {from: '2016-10-01', to: '2016-10-31'},
      {from: '2016-11-01', to: '2016-11-30'},
      {from: '2016-12-01', to: '2016-12-31'}
    ]

    Pitch.all.each do |pitch|
      rates.sample(rand(8..12)).each do |r|
        FactoryGirl.create(:rate,
          pitch:     pitch,
          from_date: r[:from],
          to_date:   r[:to],
          amount:    rand(10..40)
        )
      end
    end

    # Amenities to sites

    puts "Adding amenities to sites..."

    amenities = Amenity.all

    Site.all.each do |site|
      amenities.sample(3).each do |amenity|
        FactoryGirl.create(:site_amenity, site: site, amenity: amenity)
      end
    end

    # Bookings

    puts "Generating bookings..."

    bookers = (1..20).map { FactoryGirl.create(:booker, email: Faker::Internet.email) }

    bookings = [
      {from: '2016-01-15', to: '2016-02-15'},
      {from: '2016-02-15', to: '2016-03-15'},
      {from: '2016-03-15', to: '2016-04-15'},
      {from: '2016-04-15', to: '2016-05-15'},
      {from: '2016-05-15', to: '2016-06-15'},
      {from: '2016-06-15', to: '2016-07-15'},
      {from: '2016-07-15', to: '2016-08-15'},
      {from: '2016-08-15', to: '2016-09-15'},
      {from: '2016-09-15', to: '2016-10-15'},
      {from: '2016-10-15', to: '2016-11-15'},
      {from: '2016-11-15', to: '2016-12-15'},
      {from: '2016-12-15', to: '2016-12-20'},

      {from: '2015-01-15', to: '2015-02-15'},
      {from: '2015-02-15', to: '2015-03-15'},
      {from: '2015-03-15', to: '2015-04-15'},
      {from: '2015-04-15', to: '2015-05-15'},
      {from: '2015-05-15', to: '2015-06-15'},
      {from: '2015-06-15', to: '2015-07-15'},
      {from: '2015-07-15', to: '2015-08-15'},
      {from: '2015-08-15', to: '2015-09-15'},
      {from: '2015-09-15', to: '2015-10-15'},
      {from: '2015-10-15', to: '2015-11-15'},
      {from: '2015-11-15', to: '2015-12-15'},
      {from: '2015-12-15', to: '2015-12-20'},

      {from: '2014-01-15', to: '2014-02-15'},
      {from: '2014-02-15', to: '2014-03-15'},
      {from: '2014-03-15', to: '2014-04-15'},
      {from: '2014-04-15', to: '2014-05-15'},
      {from: '2014-05-15', to: '2014-06-15'},
      {from: '2014-06-15', to: '2014-07-15'},
      {from: '2014-07-15', to: '2014-08-15'},
      {from: '2014-08-15', to: '2014-09-15'},
      {from: '2014-09-15', to: '2014-10-15'},
      {from: '2014-10-15', to: '2014-11-15'},
      {from: '2014-11-15', to: '2014-12-15'},
      {from: '2014-12-15', to: '2014-12-20'},

      {from: '2013-01-15', to: '2013-02-15'},
      {from: '2013-02-15', to: '2013-03-15'},
      {from: '2013-03-15', to: '2013-04-15'},
      {from: '2013-04-15', to: '2013-05-15'},
      {from: '2013-05-15', to: '2013-06-15'},
      {from: '2013-06-15', to: '2013-07-15'},
      {from: '2013-07-15', to: '2013-08-15'},
      {from: '2013-08-15', to: '2013-09-15'},
      {from: '2013-09-15', to: '2013-10-15'},
      {from: '2013-10-15', to: '2013-11-15'},
      {from: '2013-11-15', to: '2013-12-15'},
      {from: '2013-12-15', to: '2013-12-20'},

      {from: '2012-01-15', to: '2012-02-15'},
      {from: '2012-02-15', to: '2012-03-15'},
      {from: '2012-03-15', to: '2012-04-15'},
      {from: '2012-04-15', to: '2012-05-15'},
      {from: '2012-05-15', to: '2012-06-15'},
      {from: '2012-06-15', to: '2012-07-15'},
      {from: '2012-07-15', to: '2012-08-15'},
      {from: '2012-08-15', to: '2012-09-15'},
      {from: '2012-09-15', to: '2012-10-15'},
      {from: '2012-10-15', to: '2012-11-15'},
      {from: '2012-11-15', to: '2012-12-15'},
      {from: '2012-12-15', to: '2012-12-20'},
    ]

    Pitch.all.each do |pitch|
      bookings.sample(rand(0..5)).each do |b| # 0..40 for search testing
        FactoryGirl.create(:booking,
          pitch: pitch,
          booker: bookers.sample,
          start_date: b[:from],
          end_date:   b[:to]
        )
      end
    end
  end
end
