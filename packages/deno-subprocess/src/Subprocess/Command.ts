import type { EffectFn1, EffectFn2, EffectFn3 } from "../../../../purescript.d.ts";

export const _new: EffectFn2<Deno.CommandOptions, string | URL, Deno.Command> = (
  opts,
  command
) => {
  return new Deno.Command(command, opts);
};

export const _output: EffectFn3<Deno.Command, EffectFn1<Deno.CommandOutput, void>, EffectFn1<Error, void>, void> = (command, onSuccess, onError) => {
  command.output()
    .then(onSuccess)
    .catch(onError);
};

export const _outputSync: EffectFn1<Deno.Command, Deno.CommandOutput> = (command) => command.outputSync();

export const _spawn: EffectFn1<Deno.Command, Deno.ChildProcess> = (command) => command.spawn();
