from datetime import datetime
from googletrans import Translator

import asyncio
import subprocess
import sys


def get_params() -> tuple[str, str]:
    """"""
    sioyek_path = sys.argv[1][1:-1]
    payload = sys.argv[2][1:-1]

    return sioyek_path, payload


# end def


async def translate(payload: str) -> str:
    """ """
    async with Translator() as translator:
        result = await translator.translate(payload, dest="es")
        print("result", result)
        return result.text


# end def


def set_message_in_status_bar(sioyek_path: str, message: str, icon="🔊") -> None:
    timestamp = datetime.now().strftime("%H:%M:%S")

    subprocess.run(
        [
            sioyek_path,
            "--execute-command",
            "set_status_string",
            "--execute-command-data",
            f"{icon} {timestamp} {message}",
        ]
    )


# end def


async def amain():
    sioyek_path, payload = get_params()
    set_message_in_status_bar(sioyek_path, "Loading...", "🌀")

    translation = await translate(payload)
    set_message_in_status_bar(sioyek_path, translation)


# end def

if __name__ == "__main__":
    try:
        asyncio.run(amain())
    except Exception as e:
        # Retry until the translation is successful.
        asyncio.run(amain())
    # end try
# end main
