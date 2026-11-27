-- Rotating 3D wireframe cube frames.
-- Inspired by github.com/obk/spinning-things and
-- github.com/RipperdocNiladri/ASCII-Art. Embedded: no command, network, or dependency.
local M = { width = 25, height = 14 }

M.frames = {
	[==[




               ,,,...
          :;+=X@XXXxx@
          :    $    .x
          ;    @#$  X
           ;=x$   $X@
           ;;;;;    +
                ::::,



]==],

	[==[




                  x==@
          :;+=x@Xx.. =
          ;     $  . x
           ;    @#$. x
            +xX$   $X@
            +++;   ,+
                ;:::



]==],

	[==[




             =x@xx==++
          ;;+, $   ,:=
           +  ,.#..  =
           +   #@#$$X@
            @X$   , =
              ++; ,+
                 ;:



]==],

	[==[




              x@x==++;;
            +=  $ .,, +
          ;+:,....    =
           +=   #@#$$X@
             @X$ ,  +=
               =+ :;
                 ;:



]==],

	[==[




              x@x=+;;:
            ==  $ ,, ;
          +=,   .@#$  +
            =..$#   Xx@
             x@x,   +=
                =: ;
                 +;



]==],

	[==[



                   ;:,
              x@=++,  :
            ==  X$    ;
          +=  .. #@#$ +
            ..  #    Xx@
             X@$     ++
                =  ;+
                 +;



]==],

	[==[



                  ;:,
              x@=+,, :
             x  X$    :
           @x ..  @$X ;
           :.X  ##   x=+
           .. X@     ++
             ,,:x= ;;
                 :;



]==],

	[==[



                 :,
              x@X. ,
             x . X  ::
           @x .   $@Xx;
           ;.XX  ##   =;
           .,  $@    ;;
             ,,::x ;;
                 :;



]==],

	[==[



                 .,
               @X  ,,
              x  X   ::
             x    $@Xx=+;
           ,@X   #$    ;
          ,;, X$@    ;;
             ,,::X= ;
                 ::;



]==],

	[==[



               ,,
              ,@X,,,
             ,X  X$ ,::
            ,X     $@X=+:
           ,@X$   $$   :
          ,+,  $$@   ::
             ,::: = :
                 :::



]==],

	[==[



              ,,,
             ,+  ,,,,,
            ,  @XX    ,;:
            , X   $$@x=:
           ,=@$$   $  :
          ,;,   $$@   :
             ,,::: = :
                  :::



]==],

	[==[



             ,,,
            , + ,,,,,
            ,  @$$   ,;,
           ,  $   $$@x,
           ,x@$$   $  ,
          ,;,   $$@  ,
             ,,,,, = ,
                  ,,,



]==],

	[==[



            :::::
            :+x  :::,+,
           :   @$$$$@ ,
           :  $     X ,
          :   $    X  ,
          ,;x@$XXXX@ ,
             ,,,,,, +,
                   ,,,



]==],

	[==[




            :=::::::::
            : @$$$$$@,
           :  $     X,
           :  $     X,
          : +x@XXXXX@,
          ,;,,,,,,,,,,




]==],

	[==[



                 ::::
            ;;;;:   =
            ;x    $$@,
           :  @#$$  X,
           :  $     X,
          , +x@XXXxx@;.
          ,;,,,,,,,....




]==],

	[==[



                ;;;;:
           ;;;;;    +
           ;=X     x ,
           :  @##$$@ ,
          :   $     X .
          ,   X ..xxx@.
          ,:+=@xxx




]==],

	[==[



                ;;;;
           +++;;   =:
           ;=X     X :
           :  @####@  ,
           ,  $   ..X...
           ,:;.X..xx=@;
              =@xx




]==],

	[==[



                 ++
             ++++ x;:
           ++      X :,
           ;xX   ##@....
           ,  @##...X ;
           .,;X   ===@
              +@==




]==],

	[==[



                 =@+
             +++= x ;:
           ++     $   ,.
           ;xX  ##@...:
           ,  @#.  $x ;
           .,.X     =@
             : x ===
              ;++



]==],

	[==[




              ===@=+;
           +++    $  ;:,
            x  .##@$,  :
            .@$#    X +
             ,x      x@
              =  +++=
               ;+



]==],

	[==[




              ==x@x=+
           ++=   X ,,;;:
            =,...#.   ;
            x . #@#   +
             @$#   $x@
              x+: ++
                ;;



]==],

	[==[




              =xx@xx=+;;
           ;+=   $.,, ;
           + ,...#    +
            =  $#@#   =
            @X$ ,  $X@
              + , ;+
               ;:;



]==],

	[==[




              xX@Xxx
           ;+=,,$..,=++
           +    #.    +
            =  #@#$  =
            @x$  , XX@
              +; , +
                ::;



]==],

	[==[




           ;+=:,,...,
           ;  xX@XXxx=@
           +    #  . =
           +  X$@#.  x
           +=x    $X@
             ;;;: ,+
                 :,



]==],
}

function M.placeholder()
	return ("\n"):rep(M.height - 1)
end

local timer
local watched = {}

function M.random()
	return M.frames[math.random(1, #M.frames)]
end

local function stop()
	if timer then
		timer:stop()
		timer:close()
		timer = nil
	end
end

function M.animate(dashboard, pos)
	stop()
	local buf, win = dashboard.buf, dashboard.win
	if not buf or not vim.api.nvim_buf_is_valid(buf) then
		return
	end
	if not watched[buf] then
		watched[buf] = true
		vim.api.nvim_create_autocmd({ "BufWipeout", "BufDelete" }, {
			buffer = buf,
			once = true,
			callback = stop,
		})
		dashboard.on("UpdatePre", stop, dashboard.augroup)
		dashboard.on("Closed", stop, dashboard.augroup)
	end
	local win_width = vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_width(win) or vim.fn.winwidth(0)
	if win_width < M.width + 16 then
		return -- too narrow: keep blank reservation instead of overlapping the menu
	end
	local start_col = math.max(0, win_width - M.width - 3)
	local row = (pos[1] or 1) - 1
	local index = math.random(1, #M.frames)
	local function draw()
		if not vim.api.nvim_buf_is_valid(buf) then
			stop()
			return
		end
		local lines = vim.split(M.frames[index], "\n")
		while #lines < M.height do
			table.insert(lines, "")
		end
		for i = 1, #lines do
			lines[i] = (" "):rep(start_col) .. lines[i]
		end
		vim.bo[buf].modifiable = true
		vim.api.nvim_buf_set_lines(buf, row, row + M.height, false, lines)
		vim.bo[buf].modifiable = false
		index = index % #M.frames + 1
	end
	draw()
	timer = vim.uv.new_timer()
	timer:start(130, 130, vim.schedule_wrap(draw))
end

return M
