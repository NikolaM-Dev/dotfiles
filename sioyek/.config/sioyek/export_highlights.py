import sys
import pathlib


def ensure_file_exists(file_path: str) -> None:
    """ """
    path = pathlib.Path(file_path)
    path.touch()


# end def


def clean_arg(arg: str) -> str:
    """ """
    return arg[1:-1].strip().replace("“", '"').replace("”", '"')


# end def


def get_args() -> tuple[str, str, int]:
    """ """
    new_args = []
    for arg in sys.argv:
        new_args.append(clean_arg(arg))

    new_args = new_args[1:]
    new_args[-1] = int(new_args[-1]) + 1

    return tuple(new_args)


# end def


def append_to_file(filename: str, text: str):
    """ """
    file = open(filename, "a")  # open in append mode
    file.write(text)
    file.close()


# end def


def main():
    """ """
    filename, highlight, page = get_args()

    full_highlight = f"- {highlight}. `page:{page}`\n".replace("..", ".")
    file_path = f"/home/nikola/library/{filename}.md"

    ensure_file_exists(file_path)
    append_to_file(file_path, full_highlight)


# end def


if __name__ == "__main__":
    main()
# end main
