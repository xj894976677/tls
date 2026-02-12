import type { Crypto } from '../types/index.ts'

// Provide a browser-compatible default for randomBytes
// so basic operations work even without explicit setCryptoImplementation()
const browserFallback: Partial<Crypto<unknown>> = {}

if (typeof globalThis !== 'undefined' && globalThis.crypto?.getRandomValues) {
	browserFallback.randomBytes = (length: number) => {
		const buffer = new Uint8Array(length)
		return globalThis.crypto.getRandomValues(buffer)
	}
}

export const crypto = { ...browserFallback } as Crypto<unknown>

export function setCryptoImplementation(impl: Crypto<unknown>) {
	Object.assign(crypto, impl)
}