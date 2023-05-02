function onCreate()
	--floating shit
	dalapsed = 0.0
	function onUpdate(elapsed)
		dalapsed = dalapsed + elapsed;
		setProperty("cubes.y", -600 + 100 * math.sin((dalapsed - 10) * 0.5));
		setProperty("cubes2.y", -600 + 200 * math.sin((dalapsed - 7) * 0.5));
	end
	
	makeLuaSprite('cubes', 'purgatory/3d_Objects', -600, -200);
	setScrollFactor('cubes', 1, 1);

	makeLuaSprite('cubes2', 'purgatory/3dBG_Objects', -600, 200);
	setScrollFactor('cubes2', 0.75, 0.75);

	addLuaSprite('cubes', false)
	addLuaSprite('cubes2', false)
end