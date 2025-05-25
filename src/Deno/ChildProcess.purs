module Deno.ChildProcess
  ( ChildProcess
  , CommandStatus
  , pid
  , status
  ) where

import Prelude

import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.Nullable (Nullable, toMaybe)
import Deno.Signal (Signal(..))
import Effect.Aff (Aff, makeAff)
import Effect.Exception (Error)
import Effect.Uncurried (EffectFn1, EffectFn3, mkEffectFn1, runEffectFn3)

foreign import data ChildProcess :: Type

type CommandStatus =
  { success :: Boolean
  , code :: Int
  , signal :: Maybe Signal
  }

type CommandStatusRaw =
  { success :: Boolean
  , code :: Int
  , signal :: Nullable String
  }

foreign import pid :: ChildProcess -> Int

foreign import _status :: EffectFn3 ChildProcess (EffectFn1 CommandStatusRaw Unit) (EffectFn1 Error Unit) Unit

stringToSignal :: String -> Maybe Signal
stringToSignal = case _ of
  "SIGABRT" -> Just SIGABRT
  "SIGALRM" -> Just SIGALRM
  "SIGBREAK" -> Just SIGBREAK
  "SIGBUS" -> Just SIGBUS
  "SIGCHLD" -> Just SIGCHLD
  "SIGCONT" -> Just SIGCONT
  "SIGEMT" -> Just SIGEMT
  "SIGFPE" -> Just SIGFPE
  "SIGHUP" -> Just SIGHUP
  "SIGILL" -> Just SIGILL
  "SIGINFO" -> Just SIGINFO
  "SIGINT" -> Just SIGINT
  "SIGIO" -> Just SIGIO
  "SIGPOLL" -> Just SIGPOLL
  "SIGUNUSED" -> Just SIGUNUSED
  "SIGKILL" -> Just SIGKILL
  "SIGPIPE" -> Just SIGPIPE
  "SIGPROF" -> Just SIGPROF
  "SIGPWR" -> Just SIGPWR
  "SIGQUIT" -> Just SIGQUIT
  "SIGSEGV" -> Just SIGSEGV
  "SIGSTKFLT" -> Just SIGSTKFLT
  "SIGSTOP" -> Just SIGSTOP
  "SIGSYS" -> Just SIGSYS
  "SIGTERM" -> Just SIGTERM
  "SIGTRAP" -> Just SIGTRAP
  "SIGTSTP" -> Just SIGTSTP
  "SIGTTIN" -> Just SIGTTIN
  "SIGTTOU" -> Just SIGTTOU
  "SIGURG" -> Just SIGURG
  "SIGUSR1" -> Just SIGUSR1
  "SIGUSR2" -> Just SIGUSR2
  "SIGVTALRM" -> Just SIGVTALRM
  "SIGWINCH" -> Just SIGWINCH
  "SIGXCPU" -> Just SIGXCPU
  "SIGXFSZ" -> Just SIGXFSZ
  _ -> Nothing

convertCommandStatus :: CommandStatusRaw -> CommandStatus
convertCommandStatus raw =
  { success: raw.success
  , code: raw.code
  , signal: toMaybe raw.signal >>= stringToSignal
  }

status :: ChildProcess -> Aff CommandStatus
status childProcess = makeAff \cb ->
  let
    onSuccess = cb <<< Right <<< convertCommandStatus
    onError = cb <<< Left
  in
    runEffectFn3 _status childProcess (mkEffectFn1 onSuccess) (mkEffectFn1 onError) *> mempty
