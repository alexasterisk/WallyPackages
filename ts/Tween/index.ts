import { Instance, Tween, TweenInfo } from "@rbxts/types";
import { TweenService } from "@rbxts/services";

function tweenNext(inst: Instance, info: TweenInfo, properties: Map<string, any>, auto?: boolean, defaultProperties?: Map<string, any>): Tween {
    const toTween = TweenService.Create(inst, info, properties)
    if (defaultProperties !== undefined) {
        defaultProperties.forEach((value, property) => {
            inst[property] = value
        })
    }
    if (auto) toTween.Play()
    return toTween
}

export default (inst: Instance | Instance[], info: TweenInfo, properties: Map<string, any>, auto?: boolean, defaultProperties?: Map<string, any>): Tween | Tween[] => {
    if (typeIs(inst, "table")) {
        const tweens: Tween[] = []
        for (const tween of inst) {
            tweens.push(tweenNext(tween, info, properties, auto, defaultProperties))
        }

        return tweens
    }

    return tweenNext(inst, info, properties, auto, defaultProperties)
}