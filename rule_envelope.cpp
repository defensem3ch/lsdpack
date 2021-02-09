#include "rule_envelope.h"

#include <cassert>

void EnvelopeRule::transform(std::deque<unsigned int>& bytes) {
    // Check values.
    for (size_t i = 1; i < 15 * 2; i += 2) {
        if (bytes[i] != 8) {
            return;
        }
    }

    // Check addresses.
    unsigned int register_addr = 0;

    for (size_t i = 0; i < 15 * 2; i += 2) {
        unsigned int addr = bytes[i];
        if (!(addr & CMD_FLAG)) {
            return;
        }
        switch (addr & 0x7f) {
            case 0x12:
            case 0x17:
            case 0x21:
                if (register_addr && ((addr & 0x7f) != register_addr)) {
                    return;
                }
                register_addr = addr & 0x7f;
                break;
            default:
                return;
        }
    }

    // OK, there is a volume decrease.
    // Let's rewrite it in the optimized form.
    bytes.clear();

    unsigned int byte;
    switch (register_addr) {
        case 0x12:
            byte = AMP_DOWN_PU0 | CMD_FLAG;
            break;
        case 0x17:
            byte = AMP_DOWN_PU1 | CMD_FLAG;
            break;
        case 0x21:
            byte = AMP_DOWN_NOI | CMD_FLAG;
            break;
        default:
            assert(false);
    }
    bytes.push_back(byte);
}

