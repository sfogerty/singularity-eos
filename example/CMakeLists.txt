#------------------------------------------------------------------------------
# © 2021-2022. Triad National Security, LLC. All rights reserved.  This
# program was produced under U.S. Government contract 89233218CNA000001
# for Los Alamos National Laboratory (LANL), which is operated by Triad
# National Security, LLC for the U.S.  Department of Energy/National
# Nuclear Security Administration. All rights in the program are
# reserved by Triad National Security, LLC, and the U.S. Department of
# Energy/National Nuclear Security Administration. The Government is
# granted for itself and others acting on its behalf a nonexclusive,
# paid-up, irrevocable worldwide license in this material to reproduce,
# prepare derivative works, distribute copies to the public, perform
# publicly and display publicly, and to permit others to do so.
#------------------------------------------------------------------------------

add_executable(get_sound_speed_press
  get_sound_speed_press.cpp)
target_link_libraries(get_sound_speed_press PRIVATE
  eos
  singularity-eos::libs
  singularity-eos::flags)

add_executable(get_sesame_state
  get_sesame_state.cpp)
target_link_libraries(get_sesame_state PRIVATE
  eos
  singularity-eos::libs
  singularity-eos::flags)
