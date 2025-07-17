extends Node

enum songs {
	# Songs
	LULLABY,
	UNFOLD,
	GLOAMING,
	VIEW,
	FLAWS,
	STARFALL,
	WASTELAND,
	HOME,
	ENDSSTART,
	ENDSEND,
	DARK,
	# Song Categories
	CAVE_AMBIENT,
}

var song_files = {
	songs.LULLABY : preload("res://Audio/Songs/Lullaby.ogg"),
	songs.UNFOLD : preload("res://Audio/Songs/Unfold.ogg"),
	songs.GLOAMING : preload("res://Audio/Songs/Gloaming.mp3"),
	songs.VIEW : preload("res://Audio/Songs/View.ogg"),
	songs.FLAWS : preload("res://Audio/Songs/Flaws.ogg"),
	songs.STARFALL : preload("res://Audio/Songs/Starfall.ogg"),
	songs.WASTELAND : preload("res://Audio/Songs/Wasteland.ogg"),
	songs.HOME : preload("res://Audio/Songs/Home.ogg"),
	songs.ENDSSTART : preload("res://Audio/Songs/EndsStart.ogg"),
	songs.ENDSEND : preload("res://Audio/Songs/EndsEnd.ogg"),
	songs.DARK : preload("res://Audio/Songs/Dark.ogg"),
}

enum effects {
	# Effects
	WIND,
	ROCK_TUMBLE1,
	ROCK_TUMBLE2,
	ROCK_TUMBLE3,
	BAT_CALL1,
	BAT_CALL2,
	BAT_CALL3,
	BARK1,
	BARK2,
	BARK3,
	CREAK1,
	CREAK2,
	CREAK3,
	CREAK4,
	CHITTER1,
	CHITTER2,
	PHOTO1,
	PHOTO2,
	DRUMS,
	DOG_PUNCH1,
	DOG_PUNCH2,
	DOG_PUNCH3,
	DOG_PUNCH4,
	DOG_PUNCH5,
	DOG_PUNCH6,
	DOG_PUNCH7,
	DOG_PUNCH8,
	DOG_PUNCH9,
	DOG_PUNCH10,
	SPIDER_PUNCH1,
	SPIDER_PUNCH2,
	SPIDER_PUNCH3,
	SPIDER_PUNCH4,
	SPIDER_PUNCH5,
	BAT_PUNCH1,
	BAT_PUNCH2,
	BAT_PUNCH3,
	BAT_PUNCH4,
	BAT_PUNCH5,
	WOOSH1,
	WOOSH2,
	WOOSH3,
	WOOSH4,
	WOOSH5,
	WOOSH6,
	ASPHALT1,
	ASPHALT2,
	ASPHALT3,
	ASPHALT4,
	ASPHALT5,
	ASPHALT6,
	DIRT1,
	DIRT2,
	DIRT3,
	DIRT4,
	DIRT5,
	DIRT6,
	STONE1,
	STONE2,
	STONE3,
	STONE4,
	STONE5,
	STONE6,
	TILE1,
	TILE2,
	TILE3,
	TILE4,
	TILE5,
	TILE6,
	METAL1,
	METAL2,
	METAL3,
	METAL4,
	METAL5,
	METAL6,
	SCAVENGE1,
	SCAVENGE2,
	SCAVENGE3,
	SCAVENGE4,
	SCAVENGE5,
	SCAVENGE6,
	HYDRANT1,
	HYDRANT2,
	HYDRANT3,
	HYDRANT4,
	HYDRANT5,
	WELD1,
	WELD2,
	WELD3,
	WELD4,
	WELD5,
	WELD6,
	BUILD1,
	BUILD2,
	BUILD3,
	BUILD4,
	BOX1,
	BOX2,
	BOX3,
	BOX4,
	POUR1,
	POUR2,
	POUR3,
	POUR4,
	EXPLOSIONCLOSE,
	EXPLOSIONFAR,
	BOATSPLASH,
	COMPUTERCLICK,
	COMPUTERBUZZ,
	METALDOOR,
	DOGBARK1,
	DOGBARK2,
	DOGBARK3,
	DOGBARK4,
	BATATTACK1,
	BATATTACK2,
	BATDEATH,
	DOGRUN,
	DOGGROWL1,
	DOGGROWL2,
	DOGGROWL3,
	DOGGROWL4,
	RATMOVEMENT,
	RATSQUEAK,
	SPIDERBITE1,
	SPIDERBITE2,
	SPIDERBITE3,
	SPIDERMOVEMENT,
	BATWING1,
	BATWING2,
	BATWING3,
	BATWING4,
	DOGYELP1,
	DOGYELP2,
	BOOKCLOSE,
	BOOKOPEN,
	CLICK1,
	CLICK2,
	CLICK3,
	CLICK4,
	CLICK5,
	ERASE1,
	ERASE2,
	ERASE3,
	ERASE4,
	PAPERFLIP1,
	PAPERFLIP2,
	PAPERFLIP3,
	PAPERFLIP4,
	PAPERPUTAWAY,
	PAPERTAKEOUT,
	WRITE1,
	WRITE2,
	WRITE3,
	WRITE4,
	WRITE5,
	WRITE6,
	WRITE7,
	BOATENGINESTOP,
	BOATENGINEIDLE,
	STONECRASH1,
	STONECRASH2,
	STONECRASH3,
	STONECRASH4,
	STONECRASH5,
	TUNNELRUMBLING,
	STONESPLASH1,
	STONESPLASH2,
	STONESPLASH3,
	STONESPLASH4,
	STONESPLASH5,
	BIGSPLASH,
	BOATCRASH,
	BIGROCK,
	DRILL1,
	DRILL2,
	DRILL3,
	DRILL4,
	DRILL5,
	DRILL6,
	DRILL7,
	ROCKFALL1,
	ROCKFALL2,
	ROCKFALL3,
	DRILLROCKS1,
	DRILLROCKS2,
	ERROR1,
	ERROR2,
	ERROR3,
	CORRECTPASSWORD,
	TYPE1,
	TYPE2,
	TYPE3,
	TYPE4,
	TYPE5,
	TYPE6,
	SINGLECORRECT,
	SINGLEERROR,
	CRATEBREAK,
	
	# Effect Categories
	CAVE_AMBIENT,
	DOG_PUNCH,
	SPIDER_PUNCH,
	BAT_PUNCH,
	WOOSH,
	ASPHALT,
	DIRT,
	STONE,
	TILE,
	METAL,
	SCAVENGE,
	HYDRANT,
	WELD,
	BUILD,
	BOX,
	POUR,
	DOGBARK,
	BATATTACK,
	DOGGROWL,
	SPIDERBITE,
	BATWING,
	DOGYELP,
	CLICK,
	ERASE,
	WRITE,
	PAPERFLIP,
	STONECRASH,
	STONESPLASH,
	OUTSIDEDESERT,
	DRILL,
	ROCKFALL,
	DRILLROCKS,
	ERROR,
	TYPE,
}

var effect_files = {
	effects.WIND : preload("res://Audio/SFX/Wind.ogg"),
	effects.ROCK_TUMBLE1 : preload("res://Audio/SFX/RockTumble1.wav"),
	effects.ROCK_TUMBLE2 : preload("res://Audio/SFX/RockTumble2.wav"),
	effects.ROCK_TUMBLE3 : preload("res://Audio/SFX/RockTumble3.wav"),
	effects.BAT_CALL1 : preload("res://Audio/SFX/Bat1.wav"),
	effects.BAT_CALL2 : preload("res://Audio/SFX/Bat2.wav"),
	effects.BAT_CALL3 : preload("res://Audio/SFX/Bat3.wav"),
	effects.BARK1 : preload("res://Audio/SFX/Bark1.wav"),
	effects.BARK2 : preload("res://Audio/SFX/Bark2.wav"),
	effects.BARK3 : preload("res://Audio/SFX/Bark3.wav"),
	effects.CREAK1 : preload("res://Audio/SFX/Creak1.wav"),
	effects.CREAK2 : preload("res://Audio/SFX/Creak2.wav"),
	effects.CREAK3 : preload("res://Audio/SFX/Creak3.wav"),
	effects.CREAK4 : preload("res://Audio/SFX/Creak4.wav"),
	effects.CHITTER1 : preload("res://Audio/SFX/Chitter1.wav"),
	effects.CHITTER2 : preload("res://Audio/SFX/Chitter2.wav"),
	effects.PHOTO1 : preload("res://Audio/SFX/Photo1.wav"),
	effects.PHOTO2 : preload("res://Audio/SFX/Photo2.wav"),
	effects.DRUMS : preload("res://Audio/SFX/Drums.mp3"),
	effects.DOG_PUNCH1 : preload("res://Audio/SFX/Punches/DogPunch1.wav"),
	effects.DOG_PUNCH2 : preload("res://Audio/SFX/Punches/DogPunch2.wav"),
	effects.DOG_PUNCH3 : preload("res://Audio/SFX/Punches/DogPunch3.wav"),
	effects.DOG_PUNCH4 : preload("res://Audio/SFX/Punches/DogPunch4.wav"),
	effects.DOG_PUNCH5 : preload("res://Audio/SFX/Punches/DogPunch5.wav"),
	effects.DOG_PUNCH6 : preload("res://Audio/SFX/Punches/DogPunch6.wav"),
	effects.DOG_PUNCH7 : preload("res://Audio/SFX/Punches/DogPunch7.wav"),
	effects.DOG_PUNCH8 : preload("res://Audio/SFX/Punches/DogPunch8.wav"),
	effects.DOG_PUNCH9 : preload("res://Audio/SFX/Punches/DogPunch9.wav"),
	effects.DOG_PUNCH10 : preload("res://Audio/SFX/Punches/DogPunch10.wav"),
	effects.SPIDER_PUNCH1 : preload("res://Audio/SFX/Punches/SpiderPunch1.wav"),
	effects.SPIDER_PUNCH2 : preload("res://Audio/SFX/Punches/SpiderPunch2.wav"),
	effects.SPIDER_PUNCH3 : preload("res://Audio/SFX/Punches/SpiderPunch3.wav"),
	effects.SPIDER_PUNCH4 : preload("res://Audio/SFX/Punches/SpiderPunch4.wav"),
	effects.SPIDER_PUNCH5 : preload("res://Audio/SFX/Punches/SpiderPunch5.wav"),
	effects.BAT_PUNCH1 : preload("res://Audio/SFX/Punches/BatPunch1.wav"),
	effects.BAT_PUNCH2 : preload("res://Audio/SFX/Punches/BatPunch2.wav"),
	effects.BAT_PUNCH3 : preload("res://Audio/SFX/Punches/BatPunch3.wav"),
	effects.BAT_PUNCH4 : preload("res://Audio/SFX/Punches/BatPunch4.wav"),
	effects.BAT_PUNCH5 : preload("res://Audio/SFX/Punches/BatPunch5.wav"),
	effects.WOOSH1 : preload("res://Audio/SFX/Punches/Woosh1.wav"),
	effects.WOOSH2 : preload("res://Audio/SFX/Punches/Woosh2.wav"),
	effects.WOOSH3 : preload("res://Audio/SFX/Punches/Woosh3.wav"),
	effects.WOOSH4 : preload("res://Audio/SFX/Punches/Woosh4.wav"),
	effects.WOOSH5 : preload("res://Audio/SFX/Punches/Woosh5.wav"),
	effects.WOOSH6 : preload("res://Audio/SFX/Punches/Woosh6.wav"),
	effects.ASPHALT1 : preload("res://Audio/SFX/Footsteps/Asphalt1.wav"),
	effects.ASPHALT2 : preload("res://Audio/SFX/Footsteps/Asphalt2.wav"),
	effects.ASPHALT3 : preload("res://Audio/SFX/Footsteps/Asphalt3.wav"),
	effects.ASPHALT4 : preload("res://Audio/SFX/Footsteps/Asphalt4.wav"),
	effects.ASPHALT5 : preload("res://Audio/SFX/Footsteps/Asphalt5.wav"),
	effects.ASPHALT6 : preload("res://Audio/SFX/Footsteps/Asphalt6.wav"),
	effects.DIRT1 : preload("res://Audio/SFX/Footsteps/Dirt1.wav"),
	effects.DIRT2 : preload("res://Audio/SFX/Footsteps/Dirt2.wav"),
	effects.DIRT3 : preload("res://Audio/SFX/Footsteps/Dirt3.wav"),
	effects.DIRT4 : preload("res://Audio/SFX/Footsteps/Dirt4.wav"),
	effects.DIRT5 : preload("res://Audio/SFX/Footsteps/Dirt5.wav"),
	effects.DIRT6 : preload("res://Audio/SFX/Footsteps/Dirt6.wav"),
	effects.STONE1 : preload("res://Audio/SFX/Footsteps/Stone1.wav"),
	effects.STONE2 : preload("res://Audio/SFX/Footsteps/Stone2.wav"),
	effects.STONE3 : preload("res://Audio/SFX/Footsteps/Stone3.wav"),
	effects.STONE4 : preload("res://Audio/SFX/Footsteps/Stone4.wav"),
	effects.STONE5 : preload("res://Audio/SFX/Footsteps/Stone5.wav"),
	effects.STONE6 : preload("res://Audio/SFX/Footsteps/Stone6.wav"),
	effects.TILE1 : preload("res://Audio/SFX/Footsteps/Tile1.wav"),
	effects.TILE2 : preload("res://Audio/SFX/Footsteps/Tile2.wav"),
	effects.TILE3 : preload("res://Audio/SFX/Footsteps/Tile3.wav"),
	effects.TILE4 : preload("res://Audio/SFX/Footsteps/Tile4.wav"),
	effects.TILE5 : preload("res://Audio/SFX/Footsteps/Tile5.wav"),
	effects.TILE6 : preload("res://Audio/SFX/Footsteps/Tile6.wav"),
	effects.METAL1 : preload("res://Audio/SFX/Footsteps/Metal1.wav"),
	effects.METAL2 : preload("res://Audio/SFX/Footsteps/Metal2.wav"),
	effects.METAL3 : preload("res://Audio/SFX/Footsteps/Metal3.wav"),
	effects.METAL4 : preload("res://Audio/SFX/Footsteps/Metal4.wav"),
	effects.METAL5 : preload("res://Audio/SFX/Footsteps/Metal5.wav"),
	effects.METAL6 : preload("res://Audio/SFX/Footsteps/Metal6.wav"),
	effects.SCAVENGE1 : preload("res://Audio/SFX/Progression/Scavenge1.wav"),
	effects.SCAVENGE2 : preload("res://Audio/SFX/Progression/Scavenge2.wav"),
	effects.SCAVENGE3 : preload("res://Audio/SFX/Progression/Scavenge3.wav"),
	effects.SCAVENGE4 : preload("res://Audio/SFX/Progression/Scavenge4.wav"),
	effects.SCAVENGE5 : preload("res://Audio/SFX/Progression/Scavenge5.wav"),
	effects.SCAVENGE6 : preload("res://Audio/SFX/Progression/Scavenge6.wav"),
	effects.HYDRANT1 : preload("res://Audio/SFX/Progression/Hydrant1.wav"),
	effects.HYDRANT2 : preload("res://Audio/SFX/Progression/Hydrant2.wav"),
	effects.HYDRANT3 : preload("res://Audio/SFX/Progression/Hydrant3.wav"),
	effects.HYDRANT4 : preload("res://Audio/SFX/Progression/Hydrant4.wav"),
	effects.HYDRANT5 : preload("res://Audio/SFX/Progression/Hydrant5.wav"),
	effects.WELD1 : preload("res://Audio/SFX/Progression/Weld1.wav"),
	effects.WELD2 : preload("res://Audio/SFX/Progression/Weld2.wav"),
	effects.WELD3 : preload("res://Audio/SFX/Progression/Weld3.wav"),
	effects.WELD4 : preload("res://Audio/SFX/Progression/Weld4.wav"),
	effects.WELD5 : preload("res://Audio/SFX/Progression/Weld5.wav"),
	effects.WELD6 : preload("res://Audio/SFX/Progression/Weld6.wav"),
	effects.BUILD1 : preload("res://Audio/SFX/Progression/Build1.wav"),
	effects.BUILD2 : preload("res://Audio/SFX/Progression/Build2.wav"),
	effects.BUILD3 : preload("res://Audio/SFX/Progression/Build3.wav"),
	effects.BUILD4 : preload("res://Audio/SFX/Progression/Build4.wav"),
	effects.BOX1 : preload("res://Audio/SFX/Progression/Box1.wav"),
	effects.BOX2 : preload("res://Audio/SFX/Progression/Box2.wav"),
	effects.BOX3 : preload("res://Audio/SFX/Progression/Box3.wav"),
	effects.BOX4 : preload("res://Audio/SFX/Progression/Box4.wav"),
	effects.POUR1 : preload("res://Audio/SFX/Progression/Pour1.wav"),
	effects.POUR2 : preload("res://Audio/SFX/Progression/Pour2.wav"),
	effects.POUR3 : preload("res://Audio/SFX/Progression/Pour3.wav"),
	effects.POUR4 : preload("res://Audio/SFX/Progression/Pour4.wav"),
	effects.EXPLOSIONCLOSE : preload("res://Audio/SFX/ExplosionClose.wav"),
	effects.EXPLOSIONFAR : preload("res://Audio/SFX/ExplosionFar.wav"),
	effects.BOATSPLASH : preload("res://Audio/SFX/boatSplash.wav"),
	effects.COMPUTERCLICK : preload("res://Audio/SFX/ComputerClick.wav"),
	effects.COMPUTERBUZZ : preload("res://Audio/SFX/computerbuzz.ogg"),
	effects.METALDOOR : preload("res://Audio/SFX/MetalDoor.ogg"),
	effects.DOGBARK1 : preload("res://Audio/SFX/Animals/Bark1.wav"),
	effects.DOGBARK2 : preload("res://Audio/SFX/Animals/Bark2.wav"),
	effects.DOGBARK3 : preload("res://Audio/SFX/Animals/Bark3.wav"),
	effects.DOGBARK4 : preload("res://Audio/SFX/Animals/Bark4.wav"),
	effects.BATATTACK1 : preload("res://Audio/SFX/Animals/BatAttack1.wav"),
	effects.BATATTACK2 : preload("res://Audio/SFX/Animals/BatAttack2.wav"),
	effects.BATDEATH : preload("res://Audio/SFX/Animals/BatDeath.wav"),
	effects.DOGRUN : preload("res://Audio/SFX/Animals/DogRun.wav"),
	effects.DOGGROWL1 : preload("res://Audio/SFX/Animals/Growl1.wav"),
	effects.DOGGROWL2 : preload("res://Audio/SFX/Animals/Growl2.wav"),
	effects.DOGGROWL3 : preload("res://Audio/SFX/Animals/Growl3.wav"),
	effects.DOGGROWL4 : preload("res://Audio/SFX/Animals/Growl4.wav"),
	effects.RATMOVEMENT : preload("res://Audio/SFX/Animals/RatMovement.wav"),
	effects.RATSQUEAK : preload("res://Audio/SFX/Animals/RatSqueak.wav"),
	effects.SPIDERBITE1 : preload("res://Audio/SFX/Animals/SpiderBite1.wav"),
	effects.SPIDERBITE2 : preload("res://Audio/SFX/Animals/SpiderBite2.wav"),
	effects.SPIDERBITE3 : preload("res://Audio/SFX/Animals/SpiderBite3.wav"),
	effects.SPIDERMOVEMENT : preload("res://Audio/SFX/Animals/SpiderMovement.wav"),
	effects.BATWING1 : preload("res://Audio/SFX/Animals/Wing1.wav"),
	effects.BATWING2 : preload("res://Audio/SFX/Animals/Wing2.wav"),
	effects.BATWING3 : preload("res://Audio/SFX/Animals/Wing3.wav"),
	effects.BATWING4 : preload("res://Audio/SFX/Animals/Wing4.wav"),
	effects.DOGYELP1 : preload("res://Audio/SFX/Animals/Yelp1.wav"),
	effects.DOGYELP2 : preload("res://Audio/SFX/Animals/Yelp2.wav"),
	effects.BOOKCLOSE : preload("res://Audio/SFX/UI/BookClose.wav"),
	effects.BOOKOPEN : preload("res://Audio/SFX/UI/BookOpen.wav"),
	effects.CLICK1 : preload("res://Audio/SFX/UI/Click1.wav"),
	effects.CLICK2 : preload("res://Audio/SFX/UI/Click2.wav"),
	effects.CLICK3 : preload("res://Audio/SFX/UI/Click3.wav"),
	effects.CLICK4 : preload("res://Audio/SFX/UI/Click4.wav"),
	effects.CLICK5 : preload("res://Audio/SFX/UI/Click5.wav"),
	effects.ERASE1 : preload("res://Audio/SFX/UI/Erase1.wav"),
	effects.ERASE2 : preload("res://Audio/SFX/UI/Erase2.wav"),
	effects.ERASE3 : preload("res://Audio/SFX/UI/Erase3.wav"),
	effects.ERASE4 : preload("res://Audio/SFX/UI/Erase4.wav"),
	effects.PAPERFLIP1 : preload("res://Audio/SFX/UI/PaperFlip1.wav"),
	effects.PAPERFLIP2 : preload("res://Audio/SFX/UI/PaperFlip2.wav"),
	effects.PAPERFLIP3 : preload("res://Audio/SFX/UI/PaperFlip3.wav"),
	effects.PAPERFLIP4 : preload("res://Audio/SFX/UI/PaperFlip4.wav"),
	effects.PAPERPUTAWAY : preload("res://Audio/SFX/UI/PaperPutAway.wav"),
	effects.PAPERTAKEOUT : preload("res://Audio/SFX/UI/PaperTakeOut.wav"),
	effects.WRITE1 : preload("res://Audio/SFX/UI/Write1.wav"),
	effects.WRITE2 : preload("res://Audio/SFX/UI/Write2.wav"),
	effects.WRITE3 : preload("res://Audio/SFX/UI/Write3.wav"),
	effects.WRITE4 : preload("res://Audio/SFX/UI/Write4.wav"),
	effects.WRITE5 : preload("res://Audio/SFX/UI/Write5.wav"),
	effects.WRITE6 : preload("res://Audio/SFX/UI/Write6.wav"),
	effects.WRITE7 : preload("res://Audio/SFX/UI/Write7.wav"),
	effects.BOATENGINESTOP : preload("res://Audio/SFX/boatEngineStop.ogg"),
	effects.BOATENGINEIDLE : preload("res://Audio/SFX/boatEngineIdle.ogg"),
	effects.STONECRASH1 : preload("res://Audio/SFX/StoneCrash1.wav"),
	effects.STONECRASH2 : preload("res://Audio/SFX/StoneCrash2.wav"),
	effects.STONECRASH3 : preload("res://Audio/SFX/StoneCrash3.wav"),
	effects.STONECRASH4 : preload("res://Audio/SFX/StoneCrash4.wav"),
	effects.STONECRASH5 : preload("res://Audio/SFX/StoneCrash5.wav"),
	effects.TUNNELRUMBLING : preload("res://Audio/SFX/TunnelRumbling.ogg"),
	effects.STONESPLASH1 : preload("res://Audio/SFX/StoneSplash1.wav"),
	effects.STONESPLASH2 : preload("res://Audio/SFX/StoneSplash2.wav"),
	effects.STONESPLASH3 : preload("res://Audio/SFX/StoneSplash3.wav"),
	effects.STONESPLASH4 : preload("res://Audio/SFX/StoneSplash4.wav"),
	effects.STONESPLASH5 : preload("res://Audio/SFX/StoneSplash5.wav"),
	effects.BIGSPLASH : preload("res://Audio/SFX/BigSplash.wav"),
	effects.BOATCRASH : preload("res://Audio/SFX/boatCrash.wav"),
	effects.BIGROCK : preload("res://Audio/SFX/bigRock.wav"),
	effects.OUTSIDEDESERT : preload("res://Audio/SFX/OutsideDesert.ogg"),
	effects.DRILL1 : preload("res://Audio/SFX/Drill1.ogg"),
	effects.DRILL2 : preload("res://Audio/SFX/Drill2.ogg"),
	effects.DRILL3 : preload("res://Audio/SFX/Drill3.ogg"),
	effects.DRILL4 : preload("res://Audio/SFX/Drill4.ogg"),
	effects.DRILL5 : preload("res://Audio/SFX/Drill5.ogg"),
	effects.DRILL6 : preload("res://Audio/SFX/Drill6.ogg"),
	effects.DRILL7 : preload("res://Audio/SFX/Drill7.ogg"),
	effects.ROCKFALL1 : preload("res://Audio/SFX/RockFall1.ogg"),
	effects.ROCKFALL2 : preload("res://Audio/SFX/RockFall2.ogg"),
	effects.ROCKFALL3 : preload("res://Audio/SFX/RockFall3.ogg"),
	effects.DRILLROCKS1 : preload("res://Audio/SFX/DrillRocks1.ogg"),
	effects.DRILLROCKS2 : preload("res://Audio/SFX/DrillRocks2.ogg"),
	effects.ERROR1 : preload("res://Audio/SFX/Error1.ogg"),
	effects.ERROR2 : preload("res://Audio/SFX/Error2.ogg"),
	effects.ERROR3 : preload("res://Audio/SFX/Error3.ogg"),
	effects.CORRECTPASSWORD : preload("res://Audio/SFX/correctPassword.ogg"),
	effects.TYPE1 : preload("res://Audio/SFX/Type1.wav"),
	effects.TYPE2 : preload("res://Audio/SFX/Type2.wav"),
	effects.TYPE3 : preload("res://Audio/SFX/Type3.wav"),
	effects.TYPE4 : preload("res://Audio/SFX/Type4.wav"),
	effects.TYPE5 : preload("res://Audio/SFX/Type5.wav"),
	effects.TYPE6 : preload("res://Audio/SFX/Type6.wav"),
	effects.SINGLECORRECT : preload("res://Audio/SFX/singleCorrect.mp3"),
	effects.SINGLEERROR : preload("res://Audio/SFX/singleError.mp3"),
	effects.CRATEBREAK : preload("res://Audio/SFX/crateBreak.ogg"),
}

# Audio Groups

@onready var CAVE_AMBIENT_songs = [songs.UNFOLD,songs.GLOAMING,songs.VIEW,songs.FLAWS,songs.STARFALL,songs.WASTELAND,songs.HOME]
@onready var CAVE_AMBIENT_effects = [effects.ROCK_TUMBLE1,effects.ROCK_TUMBLE2,effects.ROCK_TUMBLE3,
		effects.BAT_CALL1,effects.BAT_CALL2,effects.BAT_CALL3,
		effects.BARK1,effects.BARK2,effects.BARK3,effects.CHITTER1,effects.CHITTER2,
		effects.CREAK1,effects.CREAK2,effects.CREAK3,effects.CREAK4]
@onready var DOG_PUNCH_effects = [effects.DOG_PUNCH1,effects.DOG_PUNCH2,effects.DOG_PUNCH3,effects.DOG_PUNCH4,effects.DOG_PUNCH5,effects.DOG_PUNCH6,effects.DOG_PUNCH7,effects.DOG_PUNCH8,effects.DOG_PUNCH9,effects.DOG_PUNCH10]
@onready var SPIDER_PUNCH_effects = [effects.SPIDER_PUNCH1,effects.SPIDER_PUNCH2,effects.SPIDER_PUNCH3,effects.SPIDER_PUNCH4,effects.SPIDER_PUNCH5]
@onready var BAT_PUNCH_effects = [effects.BAT_PUNCH1,effects.BAT_PUNCH2,effects.BAT_PUNCH3,effects.BAT_PUNCH4,effects.BAT_PUNCH5]
@onready var WOOSH_effects = [effects.WOOSH1,effects.WOOSH2,effects.WOOSH3,effects.WOOSH4,effects.WOOSH5,effects.WOOSH6]
@onready var ASPHALT_effects = [effects.ASPHALT1,effects.ASPHALT2,effects.ASPHALT3,effects.ASPHALT4,effects.ASPHALT5,effects.ASPHALT6]
@onready var DIRT_effects = [effects.DIRT1,effects.DIRT2,effects.DIRT3,effects.DIRT4,effects.DIRT5,effects.DIRT6]
@onready var STONE_effects = [effects.STONE1,effects.STONE2,effects.STONE3,effects.STONE4,effects.STONE5,effects.STONE6]
@onready var TILE_effects = [effects.TILE1,effects.TILE2,effects.TILE3,effects.TILE4,effects.TILE5,effects.TILE6]
@onready var METAL_effects = [effects.METAL1,effects.METAL2,effects.METAL3,effects.METAL4,effects.METAL5,effects.METAL6]
@onready var SCAVENGE_effects = [effects.SCAVENGE1,effects.SCAVENGE2,effects.SCAVENGE3,effects.SCAVENGE4,effects.SCAVENGE5,effects.SCAVENGE6]
@onready var HYDRANT_effects = [effects.HYDRANT1,effects.HYDRANT2,effects.HYDRANT3,effects.HYDRANT4,effects.HYDRANT5]
@onready var WELD_effects = [effects.WELD1,effects.WELD2,effects.WELD3,effects.WELD4,effects.WELD5,effects.WELD6]
@onready var BUILD_effects = [effects.BUILD1,effects.BUILD2,effects.BUILD3,effects.BUILD4,effects.WELD1,effects.WELD2,effects.WELD3,effects.WELD4,effects.WELD5,effects.WELD6]
@onready var BOX_effects = [effects.BOX1,effects.BOX2,effects.BOX3,effects.BOX4]
@onready var POUR_effects = [effects.POUR1,effects.POUR2,effects.POUR3,effects.POUR4]
@onready var DOGBARK_effects = [effects.DOGBARK1,effects.DOGBARK2,effects.DOGBARK3,effects.DOGBARK4]
@onready var BATATTACK_effects = [effects.BATATTACK1,effects.BATATTACK2]
@onready var DOGGROWL_effects = [effects.DOGGROWL1,effects.DOGGROWL2,effects.DOGGROWL3,effects.DOGGROWL4]
@onready var SPIDERBITE_effects = [effects.SPIDERBITE1,effects.SPIDERBITE2,effects.SPIDERBITE3]
@onready var BATWING_effects = [effects.BATWING1,effects.BATWING2,effects.BATWING3,effects.BATWING4]
@onready var DOGYELP_effects = [effects.DOGYELP1,effects.DOGYELP2]
@onready var CLICK_effects = [effects.CLICK1,effects.CLICK1,effects.CLICK3,effects.CLICK4,effects.CLICK5]
@onready var ERASE_effects = [effects.ERASE1,effects.ERASE2,effects.ERASE3,effects.ERASE4]
@onready var WRITE_effects = [effects.WRITE1,effects.WRITE2,effects.WRITE3,effects.WRITE4,effects.WRITE5,effects.WRITE6,effects.WRITE7]
@onready var PAPERFLIP_effects = [effects.PAPERFLIP1,effects.PAPERFLIP2]
@onready var STONECRASH_effects = [effects.STONECRASH1,effects.STONECRASH2,effects.STONECRASH3,effects.STONECRASH4,effects.STONECRASH5]
@onready var STONESPLASH_effects = [effects.STONESPLASH1,effects.STONESPLASH2,effects.STONESPLASH3,effects.STONESPLASH4,effects.STONESPLASH5]
@onready var DRILL_effects = [effects.DRILL1,effects.DRILL2,effects.DRILL3,effects.DRILL4,effects.DRILL5,effects.DRILL6,effects.DRILL7]
@onready var ROCKFALL_effects = [effects.ROCKFALL1,effects.ROCKFALL2,effects.ROCKFALL3]
@onready var DRILLROCKS_effects = [effects.DRILLROCKS1,effects.DRILLROCKS2]
@onready var ERROR_effects = [effects.ERROR1,effects.ERROR2,effects.ERROR3]
@onready var TYPE_effects = [effects.TYPE1,effects.TYPE2,effects.TYPE3,effects.TYPE4,effects.TYPE5,effects.TYPE6]

@onready var effect_groups = {effects.CAVE_AMBIENT : CAVE_AMBIENT_effects,effects.DOG_PUNCH : DOG_PUNCH_effects,effects.SPIDER_PUNCH : SPIDER_PUNCH_effects,effects.BAT_PUNCH : BAT_PUNCH_effects, effects.WOOSH : WOOSH_effects, effects.ASPHALT : ASPHALT_effects, effects.DIRT : DIRT_effects, effects.STONE : STONE_effects, effects.TILE : TILE_effects, effects.METAL : METAL_effects, effects.SCAVENGE : SCAVENGE_effects, effects.HYDRANT : HYDRANT_effects, effects.WELD : WELD_effects, effects.BUILD : BUILD_effects, effects.BOX : BOX_effects, effects.POUR : POUR_effects,
effects.DOGBARK : DOGBARK_effects,effects.BATATTACK : BATATTACK_effects,effects.DOGGROWL : DOGGROWL_effects,effects.SPIDERBITE : SPIDERBITE_effects,effects.BATWING : BATWING_effects,effects.DOGYELP : DOGYELP_effects, effects.CLICK : CLICK_effects, effects.ERASE : ERASE_effects, effects.WRITE : WRITE_effects, effects.PAPERFLIP : PAPERFLIP_effects, effects.STONECRASH : STONECRASH_effects, effects.STONESPLASH : STONESPLASH_effects, effects.DRILL : DRILL_effects, effects.ROCKFALL : ROCKFALL_effects, effects.DRILLROCKS : DRILLROCKS_effects, effects.ERROR : ERROR_effects,
effects.TYPE : TYPE_effects}

# Songs

@onready var streamer = $SongPlayer

func play_audio(song : songs,fade_in = true):
	if streamer.playing:
		await stop_audio()
	if song == songs.CAVE_AMBIENT: # pick random song from cave ambient category
		song = CAVE_AMBIENT_songs.pick_random()
	streamer.stream = song_files[song]
	streamer.volume_linear = 0
	streamer.play()
	if fade_in:
		get_tree().create_tween().tween_property(streamer, "volume_linear", 1, 1)
	else:
		streamer.volume_linear = 1
func pause_audio():
	await get_tree().create_tween().tween_property(streamer, "volume_linear", 0, 1).finished
	streamer.stream_paused = true
func resume_audio():
	streamer.volume_linear = 0
	streamer.stream_paused = false
	get_tree().create_tween().tween_property(streamer, "volume_linear", 1, 1)
func stop_audio():
	await get_tree().create_tween().tween_property(streamer, "volume_linear", 0, 1).finished
	streamer.stop()
	return
func _on_song_player_finished() -> void:
	streamer.stream = null

# Sound Effects

func play_effect(effect : effects,fade_in = false,fade_length = 0.0,delay = 0.0,location = Vector2.ZERO,max_distance = 75.0,volume = 1.0):
	var sfx_stream
	if location == Vector2.ZERO:
		sfx_stream = AudioStreamPlayer.new()
	else:
		sfx_stream = AudioStreamPlayer2D.new()
		sfx_stream.global_position = location
		sfx_stream.max_distance = max_distance
	if volume != 1:
		sfx_stream.volume_linear = volume
	sfx_stream.set_bus("SFX_Bus")
	add_child(sfx_stream)
	sfx_stream.connect("finished",delete_effect.bind(sfx_stream))
	if effect in effect_groups.keys():
		effect = effect_groups[effect].pick_random()
	sfx_stream.stream = effect_files[effect]
	if delay:
		await get_tree().create_timer(delay).timeout
	if fade_in:
		sfx_stream.volume_linear = 0
		get_tree().create_tween().tween_property(sfx_stream, "volume_linear", volume, fade_length)
	sfx_stream.play()
func stop_effect(effect : effects,fade_length = 1.0):
	for item in get_children():
		if effect_groups.has(effect): # effect is group
			for effect_member in effect_groups[effect]:
				if item is AudioStreamPlayer and item.stream == effect_files[effect_member]:
					schedule_effect_stop(item,fade_length)
		else: # regular single effect
			if item is AudioStreamPlayer and item.stream == effect_files[effect]:
					schedule_effect_stop(item,fade_length)
func stop_all_effects(fade_length = 1.0):
	for item in get_children():
		if item is AudioStreamPlayer and item != streamer:
			schedule_effect_stop(item, fade_length)
func schedule_effect_stop(item : AudioStreamPlayer, fade_length : float):
	await get_tree().create_tween().tween_property(item, "volume_linear", 0, fade_length).finished
	if item:
		item.queue_free()
func delete_effect(item):
	item.queue_free()
func deafen_effect(effect : effects,volume_db : float):
	for item in get_children():
		if item is AudioStreamPlayer and item.stream == effect_files[effect]:
			get_tree().create_tween().tween_property(item, "volume_db", volume_db, 1)
func increase_effect(effect : effects,volume_db : float):
	for item in get_children():
		if item is AudioStreamPlayer and item.stream == effect_files[effect]:
			get_tree().create_tween().tween_property(item, "volume_db", volume_db, .5)
func search_effect(effect : effects):
	var count = 0
	if effect_groups.has(effect): # effect is group
		for item in effect_groups[effect]:
			for sub_item in get_children():
				if (sub_item is AudioStreamPlayer or sub_item is AudioStreamPlayer2D) and sub_item.stream == effect_files[item]:
					count+=1
	else: # effect is effect
		for item in get_children():
			if (item is AudioStreamPlayer or item is AudioStreamPlayer2D) and item.stream == effect_files[effect]:
				count+=1
	return count
