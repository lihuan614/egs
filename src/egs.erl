%	EGS: Erlang Game Server
%	Copyright (C) 2010  Loic Hoguin
%
%	This file is part of EGS.
%
%	EGS is free software: you can redistribute it and/or modify
%	it under the terms of the GNU General Public License as published by
%	the Free Software Foundation, either version 3 of the License, or
%	(at your option) any later version.
%
%	gasetools is distributed in the hope that it will be useful,
%	but WITHOUT ANY WARRANTY; without even the implied warranty of
%	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%	GNU General Public License for more details.
%
%	You should have received a copy of the GNU General Public License
%	along with gasetools.  If not, see <http://www.gnu.org/licenses/>.

-module(egs).
-export([start/0, reload/0]).

-define(MODULES, [egs_db, egs_game, egs_login, egs_patch, egs_proto]).

%% @doc Start all the application servers. Return the PIDs of the listening processes.

start() ->
	application:start(crypto),
	application:start(ssl),
	ssl:seed(crypto:rand_bytes(256)),
	egs_db:create(),
	Game = egs_game:start(),
	Login = egs_login:start(),
	Patch = egs_patch:start(),
	[{patch, Patch}, {login, Login}, {game, Game}].

%% @doc Reload all the modules.

reload() ->
	[code:soft_purge(Module) || Module <- ?MODULES],
	[code:load_file(Module) || Module <- ?MODULES].
