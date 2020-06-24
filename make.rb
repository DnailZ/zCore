#!

require "ruby_make_script"

desh_path = "/home/dnailz/OSH-2020-Labs/lab2/desh"

make do
    :default.from "run" do end

    # rum "./make.rb trace ls" to run zCore and trace the output
    :trace .from "setup" do
        using envir('RUST_LOG=trace') do
            r "cargo run -p linux-loader /bin/busybox", *ARGV[1..-1]
        end
    end

    # rum "./make.rb setup" to build rootfs
    :setup.from "rootfs/bin/desh" do
        r "git lfs pull"
        if !File.exist?('rootfs')
            r "make rootfs"
        end
    end

    # rum "./make.rb run ls" to run zCore and trace the output
    :run .from "setup" do
        r "cargo run -p linux-loader /bin/busybox", *ARGV[1..-1]
    end
    "rootfs/bin/desh" .from desh_path do
        cp $d[0], $t[0]
    end


    :desh .from "setup" do
        in_env('RUST_LOG=trace') do
            r "cargo run -p linux-loader /bin/desh", *ARGV[1..-1]
        end
    end
end